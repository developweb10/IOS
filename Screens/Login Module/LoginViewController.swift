//
//  LoginViewController.swift
//  Find Me
//
//  Created by Developer on 12/2/20.
//

import UIKit
import AETextFieldValidator
import SideMenu
import WebKit

class LoginViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var viewFind: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var viewLogin: UIView!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnTakeLook: UIButton!
    
    @IBOutlet weak var txtFldUsername: AETextFieldValidator!
    @IBOutlet weak var txtFldPswrd: AETextFieldValidator!
   
   
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var viewPrivacy: UIView!
    @IBOutlet weak var viewWebView: UIView!
    @IBOutlet weak var btnOption: UIButton!
    
    //MARK:- Variables
    let webView = WKWebView()

    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btnForgotPassword.setItalicUnderline()
        self.btnTakeLook.setUnderline()
       // self.txtFldUsername.addRegx(usernameRegex, withMsg: "Please enter Valid Username".localize)
        self.txtFldPswrd.addRegx(passwordRegex, withMsg: "Password must be greater than 6 digits".localize)
        
        self.checkPrivacy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        self.btnLogin.setBlueGradientBackground()
     //   self.viewFind.setLightBlueGradientBackground()
        self.btnSignUp.setRedGradientBackground()
        self.viewLogin.addshadow(top: true, left: true, bottom: false, right: true)
        self.btnSubmit.setBlueGradientBackground()
        
    }
    
    
    //MARK:- Other Functions
    func checkPrivacy(){
        guard standard.bool(forKey: "privacyAccept")else{
            self.viewPrivacy.frame = self.view.frame
            self.view.addSubview(self.viewPrivacy)
            self.viewPrivacy.layoutIfNeeded()
            self.webView.frame = self.viewWebView.frame
            self.viewWebView.addSubview(self.webView)
            
            if let url = URL(string: "http://182.73.95.220/findme/Api/privacyPolicy") {
                self.webView.load(URLRequest(url: url))
            }
            
            webView.navigationDelegate = self
            self.webView.layoutIfNeeded()
            return
        }
    }


    //MARK:- IBActions
    @IBAction func btnActionSignUp(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnActionTakeLook(_ sender: UIButton) {
        self.setMainScreen()
    }
    
    
    @IBAction func btnActionLogin(_ sender: UIButton) {
        
        guard self.txtFldUsername.validate() && self.txtFldPswrd.validate() else{
            return
        }
        
        guard (standard.string(forKey: "fcmToken") ?? "") != "" else{
            self.showalert(msg: "There is error occured in connecting with Firebase.\nPlease try again!!!".localize)
            return
        }
        self.loginApi()
        
        
      //  self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnActionForgotPassword(_ sender: UIButton) {
        let alert = UIAlertController(title: "Forgot Password?".localize, message: "Please enter email address and we will send Reset Password mail".localize, preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter Email Address".localize
        }
        
        alert.addAction(UIAlertAction(title: "OK".localize, style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text ?? "")")
            guard (textField?.text ?? "") != "" else{return}
            self.forgotPswrdApi(email: textField?.text ?? "")
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnActionAcceptPrivacy(_ sender: UIButton) {
        
        if let img = sender.imageView?.image{
            if img == #imageLiteral(resourceName: "imgUnbox") {
                sender.setImage(#imageLiteral(resourceName: "imgCheckBox"), for: .normal)
                
            }else{
                sender.setImage(#imageLiteral(resourceName: "imgUnbox"), for: .normal)
            }
        }
    }
    
    @IBAction func btnActionSubmitPrivacy(_ sender: Any) {
        guard (self.btnOption.imageView?.image ?? UIImage()) == #imageLiteral(resourceName: "imgCheckBox") else{
            self.showalert(msg: "Please accept Terms and Conditions!!!".localize)
            return
        }
        standard.setValue(true, forKey: "privacyAccept")
        self.viewPrivacy.removeFromSuperview()
    }
    
    
    
    
    //MARK:- Api's
    func loginApi(){
        let param = ["email": self.txtFldUsername.text ?? "",
                     "password": self.txtFldPswrd.text ?? "",
                     "device_type": "IOS",
                     "device_token": standard.string(forKey: "fcmToken") ?? "123456"
        ]
        
        print(param)
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitPostRawApi(url: mainURL + "userLogin", params: param as [String: AnyObject], header: nil) { (json) in
            print(json)
            if json["status"].intValue == 1{
                
                
                standard.setValue(json["result"]["id"].stringValue, forKey: "userId")
                standard.setValue(json["result"]["email"].stringValue, forKey: "emailId")
                let username = json["result"]["first_name"].stringValue + " " + json["result"]["last_name"].stringValue
                standard.setValue(username, forKey: "username")
                standard.setValue(json["result"]["profile_image"].stringValue, forKey: "profile")
                
                standard.setValue(json["result"]["phone_no"].stringValue, forKey: "mobile")
                
                standard.setValue(self.txtFldPswrd.text ?? "", forKey: "pswrd")
                
                DispatchQueue.main.async {
                    self.setMainScreen()
                    self.view.stopProgresshub()
                }
                
            }
            else{
                self.showalert(msg: json["msg"].stringValue)
                self.view.stopProgresshub()
            }
            
            
        } failure: { (error) in
            print(error)
            self.showalert(msg: error)
            self.view.stopProgresshub()
        }

        
    }
    
    
    func forgotPswrdApi(email: String) {
    
        let param = ["email": email]
        print(param)
        
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitPostRawApi(url: mainURL + "forgotPassword", params: param as [String : AnyObject], header: nil) { (json) in
            print(json)
            DispatchQueue.main.async {
                self.showalert(msg: json["msg"].stringValue)
            }
            self.view.stopProgresshub()
        } failure: { (error) in
            print(error)
            self.showalert(msg: error)
            self.view.stopProgresshub()
        }

        
    }
    
    //MARK:- OtherFunction
    
    func setMainScreen(takeLook: Bool = false) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        let menu = UISideMenuNavigationController(rootViewController: vc!)
        menu.isNavigationBarHidden = true
        
        
      //  let mainNav = UINavigationController(rootViewController: menu)
        let sideMenu = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        let rightMenu = UISideMenuNavigationController(rootViewController: sideMenu!)
        rightMenu.menuWidth = (appDelegate.window?.rootViewController?.view.frame.width ?? self.view.frame.width) * 0.78
 
        SideMenuManager.default.menuShadowColor = .black
        SideMenuManager.default.menuShadowRadius = 5
        SideMenuManager.default.menuShadowOpacity = 0.5
        
        
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuRightNavigationController = rightMenu
        
        appDelegate.window?.rootViewController = menu
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    
}

extension LoginViewController: WKNavigationDelegate, WKUIDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let textSize = 250
        let javascript = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%'"
        webView.evaluateJavaScript(javascript) { (response, error) in
            print()
        }
    }

}
