//
//  ProfileViewController.swift
//  FindMe2
//
//  Created by Developer on 12/15/20.
//

import UIKit
import SideMenu

class ProfileViewController: UIViewController,  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var txtfieldEmail: UITextField!
    @IBOutlet weak var txtfieldMobile: UITextField!
    @IBOutlet weak var txtfldPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewProfile: UIView!
    

    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
        self.btnSubmit.setBlueGradientBackground()
        self.viewProfile.layer.borderColor = BlueRightColor.cgColor
    }
    
    
    //MARK:- Other functions
    func setUI(){
        self.lblUserName.text = ""
        self.lblAddress.text = ""
        
        self.txtfieldEmail.text = ""
        self.txtfldPassword.text = ""
        self.txtfieldMobile.text = ""
        
       
        
    }
    
    
    //MARK:- IBActions
    @IBAction func btnActionSubmit(_ sender: UIButton) {
        
        guard (standard.string(forKey: "userId") ?? "") != "" else{
            self.showalert(msg: "Please login first to use feature's of the app!!".localize)
            return
        }
        
        self.updateProfile()
    }
    
    @IBAction func btnActionMenu(_ sender: UIButton) {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        
        present(SideMenuManager.default.menuRightNavigationController ?? sideMenu!, animated: true, completion: nil)
    }
    
    
    @IBAction func btnActionEditProfile(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image".localize, message: "Please Select any One Option".localize, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera".localize, style: .default, handler: { (alert) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery".localize, style: .default, handler: { (alert) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK:- APi
    func viewUserProfile(){
        let param = ["user_id": standard.string(forKey: "userId") ?? ""]
        print(param)
        
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitPostRawApi(url: mainURL + "viewProfile", params: param as [String: AnyObject], header: [:]) { (json) in
            print(json)
            if let data = json["data"].array , data.count > 0{
            self.imgProfile.sd_setImage(with: URL(string: data[0]["profile_image"].stringValue)!) { (image, error, cache, url) in
                if error == nil{
                    self.imgProfile.image = image
                }
            }
            
                self.lblUserName.text = data[0]["first_name"].stringValue + " " + data[0]["last_name"].stringValue
            
                self.lblAddress.text = data[0]["address"].stringValue
                self.txtfieldEmail.text = data[0]["email"].stringValue
                self.txtfieldMobile.text = standard.string(forKey: "mobile") ?? ""
                self.txtfldPassword.text = standard.string(forKey: "pswrd") ?? ""
            }
            
            self.view.stopProgresshub()
        } failure: { (error) in
            print(error)
            self.view.stopProgresshub()
        }

    }
    
    func updateProfile(){
        let param = [
            "user_id": standard.string(forKey: "userId") ?? "",
            "email": self.txtfieldEmail.text ?? "",
            "password": self.txtfldPassword.text ?? ""
            //"mobile_number": self.txtfieldMobile.text ?? ""
        ]
        
        print(param)
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitPostRawApi(url: mainURL + "updatePassword", params: param as [String: AnyObject], header: [:]) { (json) in
            print(json)
            
            standard.setValue(self.txtfieldMobile.text ?? "", forKey: "mobile")
            standard.setValue(self.txtfldPassword.text ?? "", forKey: "pswrd")
            
            self.view.stopProgresshub()
        } failure: { (error) in
            print(error)
            self.view.stopProgresshub()
        }

        
    }

    
    
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
}
