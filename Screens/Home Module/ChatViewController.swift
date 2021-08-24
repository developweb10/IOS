//
//  ChatViewController.swift
//  Find Me
//
//  Created by Developer on 12/7/20.
//

import UIKit
import SideMenu
import Firebase
import FirebaseDatabase
import SwiftyJSON
import IQKeyboardManager

class ChatViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableheight: NSLayoutConstraint!
    @IBOutlet weak var viewRequestHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTextMsgHeight: NSLayoutConstraint!
    @IBOutlet weak var txtView: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    //MARK:- variables
    var model = FriendListModel.init(json: JSON(JSON.self))
    var dictChat = [Message]()
   
    var node = ""
    var nodeReverse = ""
    var isNodeReverse = false

    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        node = (standard.string(forKey: "userId") ?? "") + "_" + (self.model.id ?? "")
        nodeReverse = (self.model.id ?? "") + "_" + (standard.string(forKey: "userId") ?? "")
        self.setUI()
        self.getChat()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewDidLayoutSubviews() {
        self.viewTop.setLightBlueGradientBackground()
        self.tableheight.constant = self.scrollView.frame.height - (((self.model.status ?? "") != "accepted") ? 80 : 55)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    //MARK:- Other Functions
    func setUI(){
        self.viewRequestHeight.constant = ((self.model.status ?? "") != "accepted") ? 80 : 0
        self.viewTextMsgHeight.constant = ((self.model.status ?? "") != "accepted") ? 0 : 55
        
        self.imgProfile.sd_setImage(with: URL(string: self.model.profileImage ?? "")!) { (image, error, cache, url) in
            if error == nil{
                self.imgProfile.image = image
            }
        }
        
        self.lblName.text = (self.model.firstName ?? "") + " " + (self.model.lastName ?? "")
        self.lblEmail.text = self.model.address ?? ""
    }
    
    func getChat() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        var ref: DatabaseReference!
        ref = Database.database().reference()
       
        ref.child("message").child(self.node).observe(.value) { (snapshot) in
                if snapshot.exists(){
                    self.isNodeReverse = false
                    self.dictChat.removeAll()
                    
                    if snapshot.childrenCount > 0 {
                        for message in snapshot.children.allObjects as! [DataSnapshot] {
                            let messageObject = message.value as? [String: AnyObject]
                            let chatMessage = Message.init()
                            
                            chatMessage.idSender = messageObject?["idSender"] as? String
                            chatMessage.idReceiver = messageObject?["idReceiver"] as? String
                            chatMessage.text = messageObject?["text"] as? String
                            
                            self.dictChat.append(chatMessage)
                            
                        }
                        
                        
                        
                        print(self.dictChat)
                        self.tableView.reloadData()
                        self.scrollToBottom()
                        self.view.stopProgresshub()
                    }else{
                        self.view.stopProgresshub()
                    }
                }else{
                    ref.child("message").child(self.nodeReverse).observe(.value) { (snapshot) in
                        self.isNodeReverse = true
                            self.dictChat.removeAll()
                           
                            if snapshot.childrenCount > 0 {
                                for message in snapshot.children.allObjects as! [DataSnapshot] {
                                    let messageObject = message.value as? [String: AnyObject]
                                    let chatMessage = Message.init()
                                    
                                    chatMessage.idSender = messageObject?["idSender"] as? String
                                    chatMessage.idReceiver = messageObject?["idReceiver"] as? String
                                    chatMessage.text = messageObject?["text"] as? String
                                    
                                    self.dictChat.append(chatMessage)

                                }
                                
                              
                                
                                print(self.dictChat)
                                self.tableView.reloadData()
                                self.scrollToBottom()
                                self.view.stopProgresshub()
                            }else{
                                self.view.stopProgresshub()
                            }
                        }
                }
            }
    }
    
    func sendTextMessage() {
       // let time = self.getTime()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let textMessage = self.txtView.text
        let message :[String:Any] = ["text": textMessage ?? "",
                                     "idSender":standard.string(forKey: "userId") ?? "",
                                     "idReceiver": self.model.id ?? "",
                                     "timestamp": ""
        ]
        DispatchQueue.main.async {
            self.saveLastMessageApi(text: self.txtView.text ?? "")
            self.txtView.text = nil
            self.txtView.resignFirstResponder()
            
        }
        
        
        let node = (standard.string(forKey: "userId") ?? "") + "_" + (self.model.id ?? "")
        
        ref.child("message").child(self.isNodeReverse ? nodeReverse : node).childByAutoId().updateChildValues(message)
        
       
    }
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {

            self.tableView.scrollToRow(at: IndexPath(row: self.dictChat.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    
    //MARK:- IBActions
    @IBAction func btnActionMenu(_ sender: UIButton) {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        
        present(SideMenuManager.default.menuRightNavigationController ?? sideMenu!, animated: true, completion: nil)
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionAccept(_ sender: Any) {
        self.friendRequestResponse(status: "accepted")
    }
    
    @IBAction func btnActionDecline(_ sender: Any) {
        self.friendRequestResponse(status: "declined")
    }
    
    @IBAction func btnActionSaveFLater(_ sender: Any) {
        self.friendRequestResponse(status: "saveflater")
    }
    
    
    @IBAction func btnActionSend(_ sender: Any) {
        guard self.txtView.text != nil else{return}
        self.sendTextMessage()
    }
    
    
    
    //MARK:- Api
    func friendRequestResponse(status: String){
        let param = [
            "user_id": standard.string(forKey: "userId") ?? "",
            "sender_id": self.model.id ?? "",
            "status": status
        ]
        
        print(param)
        
        self.view.startProgressHub()
        ApiInteraction.sharedInstance.funcToHitPostRawApi(url: mainURL + "friendrequest", params: param as [String: AnyObject], header: [:]) { (json) in
            print(json)
            
            if status == "declined"{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.model.status = "accepted"
                self.setUI()
                self.tableView.reloadData()
            }
            
            self.view.stopProgresshub()
        } failure: { (error) in
            print(error)
            self.showalert(msg: error)
            self.view.stopProgresshub()
        }

        
    }
    
    
    func saveLastMessageApi(text: String){
        let param = [
            "user_id": standard.string(forKey: "userId") ?? "",
            "recevier_id": self.model.id ?? "",
            "m_content": text
        ]
        print(param)
        
        self.view.startProgressHub()
        
        ApiInteraction.sharedInstance.funcToHitPostRawApi(url: mainURL + "savelast_messages", params: param as [String: AnyObject], header: [:]) { (json) in
            print(json)
            
            self.view.stopProgresshub()
            
        } failure: { (error) in
            print(error)
            self.view.stopProgresshub()
        }

        
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = ((dictChat[indexPath.row].idSender ?? "") == (standard.string(forKey: "userId") ?? "")) ? "sender" : "receiver"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? HomeTableViewCell
        cell?.viewBorder.addBorderShadow(radius: 2)
        cell?.viewBorder.layer.cornerRadius = (cell?.viewBorder.frame.height)! / 2
        
        cell?.lblMsg.text = self.dictChat[indexPath.row].text ?? ""
        
        
        cell?.viewBorder.backgroundColor = ((dictChat[indexPath.row].idSender ?? "") == (standard.string(forKey: "userId") ?? "")) ? "#DBFBFF".hexStringToUIColor() : "#F1F1F1".hexStringToUIColor()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
