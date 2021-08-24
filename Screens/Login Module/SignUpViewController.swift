//
//  SignUpViewController.swift
//  Find Me
//
//  Created by Developer on 12/2/20.
//

import UIKit
import AETextFieldValidator

class SignUpViewController: UIViewController,  UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgSelfie: UIImageView!
    
    @IBOutlet weak var viewUploadID: UIView!
    @IBOutlet weak var viewSelfieImage: UIView!
    
    @IBOutlet weak var viewFind: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var viewSignUp: UIView!
    
    @IBOutlet weak var txtfldUserName: AETextFieldValidator!
    @IBOutlet weak var txtfldLastName: AETextFieldValidator!
    @IBOutlet weak var txtfldDOB: AETextFieldValidator!
    @IBOutlet weak var txtfldGender: AETextFieldValidator!
    @IBOutlet weak var txtfldPhone: AETextFieldValidator!
    @IBOutlet weak var txtfldAddress: AETextFieldValidator!
    @IBOutlet weak var txtfldPswrd: AETextFieldValidator!
    @IBOutlet weak var txtfldConfirmPswrd: AETextFieldValidator!
    @IBOutlet weak var txtfldEmail: AETextFieldValidator!
    
    
    //MARK:- variables
    var imgUploadID = false
    let picker = UIPickerView()
    var gender = ["Male","Female","Diverse"]
    
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUI()
    }
    
    override func viewDidLayoutSubviews() {
       // self.viewFind.setLightBlueGradientBackground()
        self.btnSignUp.setRedGradientBackground()
        self.viewSignUp.addshadow(top: true, left: true, bottom: false, right: true)
    }

    //MARK:- Other Functions
    func setUI() {
        self.btnSignUp.setRedGradientBackground()
//        self.viewSignUp.addshadow(top: true, left: true, bottom: false, right: true)
        self.viewUploadID.layer.borderColor = UIColor.lightGray.cgColor
        self.viewSelfieImage.layer.borderColor = UIColor.lightGray.cgColor
        self.txtfldEmail.addRegx(emailRegx, withMsg: "Please enter Valid Email Address".localize)
        self.txtfldConfirmPswrd.addConfirmValidation(to: self.txtfldPswrd, withMsg: "Both Password not matched".localize)
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = .white
        self.txtfldGender.inputView = picker
    }
    
    //MARK:- @OBjc func
    @objc func datePickerTap(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.txtfldDOB.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK:- IBActions
    @IBAction func btnActionBack(_ sender: UIButton) {
        
        guard self.imgProfile.image != nil else{
            self.showalert(msg: "Please upload PhotoID".localize)
            return
        }
        guard self.txtfldUserName.validate() && self.txtfldLastName.validate() && self.txtfldDOB.validate() && self.txtfldGender.validate() && self.txtfldPhone.validate() && self.txtfldEmail.validate() && self.txtfldAddress.validate() && self.txtfldPswrd.validate() && self.txtfldConfirmPswrd.validate() else{
            
            return
        }
        self.signUpApi()
    }
    
    
    @IBAction func btnActionUploadID(_ sender: UIButton) {
        
        self.imgUploadID = true
        
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
    
    
    @IBAction func btnActionUploadSelfie(_ sender: UIButton) {
        self.imgUploadID = false
        
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
            self.imgUploadID ? (self.imgProfile.image = img) : (self.imgSelfie.image = img)
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imgUploadID ? (self.imgProfile.image = img) : (self.imgSelfie.image = img)
        }

        picker.dismiss(animated: true) {
           
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtfldGender{
            if textField.text == ""{
                textField.text = self.gender[0].localize
            }
        }else if textField == self.txtfldDOB{
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            datePicker.backgroundColor = .white
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerTap(_ :)), for: .valueChanged)
        }
    }
    
    //MARK:- Api's
    func signUpApi(){
        let param = [
            "name": self.txtfldUserName.text!,
            "last_name": self.txtfldLastName.text!,
            "address": self.txtfldAddress.text!,
            "date_of_birth": self.txtfldDOB.text!,
            "email": self.txtfldEmail.text ?? "",
            "password": self.txtfldPswrd.text ?? "",
            "repassword": self.txtfldConfirmPswrd.text ?? "",
            "phone_no": self.txtfldPhone.text ?? "",
            "gender": self.txtfldGender.text ?? "",
            "device_type": "IOS",
            "device_token": standard.string(forKey: "fcmToken") ?? "123456"
        ]
        
        print(param)
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitMultipartApi(url: mainURL + "registration", params: param as [String: AnyObject], imageArray: [self.imgProfile.image ?? UIImage(), self.imgSelfie.image ?? UIImage()], imgname: ["profile_id","profile_image"], header: nil) { (json) in
            print(json)
            if json["status"].intValue == 1{
              //  self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "SetUpAccountViewController") as? SetUpAccountViewController
                    vc?.isSignUp = true
                    vc?.userId = json["result"]["id"].string ?? ""
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
            }else{
                self.showalert(msg: json["msg"].stringValue)
            }
            
            self.view.stopProgresshub()
        } failure: { (error) in
            print(error)
            self.showalert(msg: error)
            self.view.stopProgresshub()
        }

    }
    

}

//MARK:- extension PickerViewDelegate and DataSource
extension SignUpViewController: UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.gender[row].localize
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtfldGender.text = self.gender[row].localize
    }
}
