//
//  SetUpAccountViewController.swift
//  Find Me
//
//  Created by Developer on 12/4/20.
//

import UIKit
import AETextFieldValidator
import SideMenu
import BSImagePicker
import Alamofire
import SwiftyJSON

class SetUpAccountViewController: UIViewController,  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewUploadID: UIView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtfldNickNamee: AETextFieldValidator!
    
    @IBOutlet weak var viewFind: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    //MARK:- variables
    var imagePicker = ImagePickerController()
    var imgArray = [UIImage]()
    var isSignUp = false
    var userId = String()
    var Paymentstatus = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUI()
        self.viewUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
    //    self.viewFind.setLightBlueGradientBackground()
        self.btnCreate.setBlueGradientBackground()
        self.viewSignUp.addshadow(top: true, left: true, bottom: false, right: true)
    }

    //MARK:- Other Functions
    func setUI() {
       
        self.navigationController?.isNavigationBarHidden = true
        self.viewUploadID.layer.borderColor = UIColor.lightGray.cgColor
        self.viewUploadID.layer.borderColor = UIColor.lightGray.cgColor
        
        self.imagePicker.settings.selection.max = 3
        self.imagePicker.settings.theme.selectionStyle = .numbered
        self.imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = false
        
        self.btnMenu.isHidden = self.isSignUp
        self.btnBack.isHidden = !self.isSignUp
        
        self.userId = self.userId == "" ? (standard.string(forKey: "userId") ?? "") : self.userId
    }
    
    //MARK:- IBActions
    @IBAction func btnActionBack(_ sender: Any) {
        DispatchQueue.main.async {
            appDelegate.check()
        }
    }
    
    @IBAction func showMenu(_ sender: UIButton){
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        present(SideMenuManager.default.menuRightNavigationController ?? sideMenu!, animated: true, completion: nil)
    }
    
    @IBAction func btnActionUploadID(_ sender: UIButton) {
        
        guard (standard.string(forKey: "userId") ?? "") != "" else{
            self.showalert(msg: "Please login first to use feature's of the app!!".localize)
            return
        }
        
        self.presentImagePicker(imagePicker) { (asset) in
            print("Selected: \(asset)")
        } deselect: { (asset) in
            print("Deselected: \(asset)")
        } cancel: { (assets) in
            print("Cancelled with selections: \(assets)")
        } finish: { (assets) in
            print("Finished with selections: \(assets)")
            
            DispatchQueue.main.async {
                
                for i in 0..<assets.count{
                    self.imgArray.append(assets[i].getAssetThumbnail())
                }
                self.imgProfile.image = self.imgArray[0]
            }
        }
    }
    
    
    @IBAction func btnActionCreateQRcode(_ sender: Any) {
        
       
        
        guard (standard.string(forKey: "userId") ?? "") != "" else{
            self.showalert(msg: "Please login first to use feature's of the app!!".localize)
            return
        }
        
        
        guard self.imgProfile.image != nil else{
            self.showalert(msg: "Please upload atleast one image. You can upoad max 3 images".localize)
            return
        }
        
        guard self.txtfldNickNamee.validate() else{
            return
        }
        
        
        self.txtfldNickNamee.resignFirstResponder()
        
        
        guard self.Paymentstatus else{
            
           
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Alert".localize, message: "Please make Payment First!!!".localize, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localize, style: .default, handler: { (alert) in
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
                    vc?.userId = self.userId
                    vc?.delegate = self
                    self.present(vc!, animated: true, completion: nil)
                }))
               self.present(alert, animated: true, completion: nil)
            }
            self.view.stopProgresshub()
            return
        }
        
        
        setUpActionApi()
    }
    
    //MARK:- Other Functions
    ///function to open Camera to take picture.
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerController.SourceType.camera
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }else{
            self.showalert(msg: "You don't have camera".localize)
        }
    }
    
    ///function to open Gallery
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }else{
            self.showalert(msg: "You don't have permission to access gallery.".localize)
        }
    }
    
    //MARK:- ImagePicker Delegates
    ///function will be called when user selects image from gallery/Camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
             self.imgProfile.image = img
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imgProfile.image = img
        }

        picker.dismiss(animated: true) {
           
        }
    }
    
    //MARK:- Api's
    func setUpActionApi(){
        
       let qrImg = UIImage.generateQRCode(standard.string(forKey: "userId") ?? "", 100, nil, .black)?.convertImageToBase64String()
        
        let param = [
            "user_id": standard.string(forKey: "userId") ?? "",
            "nickname": self.txtfldNickNamee.text ?? "",
            "qr_code":  qrImg ?? ""
        ] as [String : Any]
        
       // print(param)
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitMultipartImageDataApi(url: mainURL + "setupAccount", params: param as [String: AnyObject], imageArray: self.imgArray, imgname: "profile_picture", header: [:]) { (json) in
            print(json)
            let alert = UIAlertController(title: "Alert", message: "QR created successfully", preferredStyle: .alert)
            let done = UIAlertAction(title: "OK", style: .default) { (alert) in
                print("")
                DispatchQueue.main.async {
                    let alertOption = UIAlertController(title: "Alert".localize, message: "Do you want to share this QR code with your friends?".localize, preferredStyle: .actionSheet)
                    let  yes = UIAlertAction(title: "Yes".localize, style: .default) { (alert) in
                        //show activity
                        DispatchQueue.main.async {
                            if let name = URL(string: json["result"]["qr_code"].stringValue), !name.absoluteString.isEmpty {
                                    let objectsToShare = [name]
                                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                                    self.present(activityVC, animated: true, completion: nil)
                                }else  {
                                    // show alert for not available
                                }
                        }
                    }
                    let no = UIAlertAction(title: "No".localize, style: .cancel, handler: nil)
                    
                    alertOption.addAction(no)
                    alertOption.addAction(yes)
                    self.present(alertOption, animated: true, completion: nil)
                }
            }
            alert.addAction(done)
            self.present(alert, animated: true) {
               
            }
            self.view.stopProgresshub()
        } failure: { (error) in
            print(error)
            self.view.stopProgresshub()
        }

    }
    
    
    
    func viewUserProfile(){
        
        
        
        let param = ["user_id": self.userId]
        print(param)
        
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitPostRawApi(url: mainURL + "viewProfile", params: param as [String: AnyObject], header: [:]) { (json) in
            print(json)
            if let data = json["data"].array , data.count > 0{
            
                if self.isSignUp{
                    standard.setValue(self.userId, forKey: "userId")
                    standard.setValue(data[0]["email"].stringValue, forKey: "emailId")
                    let username = data[0]["first_name"].stringValue + " " + data[0]["last_name"].stringValue
                    standard.setValue(username, forKey: "username")
                    standard.setValue(data[0]["profile_image"].stringValue, forKey: "profile")
                    
                    standard.setValue(json["result"]["phone_no"].stringValue, forKey: "mobile")
                    standard.setValue(json["result"]["password"].stringValue, forKey: "pswrd")
                }
                
                self.Paymentstatus = data[0]["payment_status"].stringValue == "approved"
                
                self.view.stopProgresshub()
            }else{
                
                self.view.stopProgresshub()
            }
        } failure: { (error) in
            print(error)
            self.view.stopProgresshub()
        }

    }
    

}
 

extension SetUpAccountViewController: paymentSuccess{
    func didPaymentSuccess() {
        setUpActionApi()
    }
}
