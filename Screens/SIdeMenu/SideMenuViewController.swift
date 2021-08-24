//
//  SideMenuViewController.swift
//  Find Me
//
//  Created by Developer on 12/4/20.
//

import UIKit
import SideMenu
import SDWebImage


class SideMenuViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    //MARK:- Variables
    var titleArray = ["Profile","Verification","Settings","Contact Us"]
    var selectedIndex = 0
    var imgArray = [#imageLiteral(resourceName: "imgUser"),#imageLiteral(resourceName: "imguserVerified"),#imageLiteral(resourceName: "imgSettings"),#imageLiteral(resourceName: "imgContactUs")]

    
    let viewControllersIdentifier = ["HomeViewController","SetUpAccountViewController","ProfileViewController","ContactUsViewController"]

    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblUsername.text = standard.string(forKey: "username") ?? ""
        self.lblEmail.text = standard.string(forKey: "emailId") ?? ""
        self.imgProfile.sd_setImage(with: URL(string: standard.string(forKey: "profile") ?? "")) { (image, error, cache, url) in
            if error == nil{
                self.imgProfile.image = image
            }else{
                self.imgProfile.image = #imageLiteral(resourceName: "imgCamera")
            }
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    

    //MARK:- IBActions
    @IBAction func btnActionClose(_ sender: UIButton) {
        SideMenuManager.default.menuRightNavigationController?.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func btnActionLogout(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout?".localize, message: "Are you sure you want to logout?".localize, preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Confirm".localize, style: .default) { (alert) in
            
            standard.setValue(nil, forKey: "userId")
            standard.setValue(nil, forKey: "username")
            standard.setValue(nil, forKey: "emailId")
            standard.setValue(nil, forKey: "profile")
            standard.setValue(nil, forKey: "mobile")
            standard.setValue(nil, forKey: "pswrd")
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            appDelegate.window?.rootViewController = vc
            appDelegate.window?.makeKeyAndVisible()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}

//MARK:- Extension TableViewDelegate and DataSources
extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let viewBorder = cell.viewWithTag(1) {
            viewBorder.backgroundColor = (selectedIndex == indexPath.row) ? .white : "#00031C".hexStringToUIColor()
            
        }
        
        if let img = cell.viewWithTag(2) as? UIImageView{
            img.image = self.imgArray[indexPath.row]
            img.tintColor = (self.selectedIndex == indexPath.row) ? "#00031C".hexStringToUIColor() : .white
            img.image = img.image?.withRenderingMode(.alwaysTemplate)
        }
        
        if let lbl = cell.viewWithTag(3) as? UILabel{
            lbl.text = self.titleArray[indexPath.row].localize
            lbl.textColor = (self.selectedIndex == indexPath.row) ? "#00031C".hexStringToUIColor() : .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        if let nav = appDelegate.window?.rootViewController as? UISideMenuNavigationController{
            let vc = storyboard?.instantiateViewController(withIdentifier: viewControllersIdentifier[indexPath.row])
            nav.viewControllers[0] = vc!
            nav.popToRootViewController(animated: true)
        }
        SideMenuManager.default.menuRightNavigationController?.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    
}
