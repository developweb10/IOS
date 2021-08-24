//
//  VerificationViewController.swift
//  Find Me
//
//  Created by Developer on 12/7/20.
//

import UIKit
import SideMenu

class VerificationViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnBack: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        self.btnBack.setBlueGradientBackground()
    }
    
    
    //MARK:- IBActions
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionShowMenu(_ sender: Any) {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        
        present(SideMenuManager.default.menuRightNavigationController ?? sideMenu!, animated: true, completion: nil)
    }
    
}
