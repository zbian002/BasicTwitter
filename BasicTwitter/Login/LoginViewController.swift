//
//  LoginViewController.swift
//  BasicTwitter
//
//  Created by Zhen Bian on 07/10/2017.
//  Copyright © 2017年 Zhen Bian. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func login(_ sender: Any) {
        
        guard let username = usernameTf.text, let password = passwordTf.text else { return }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            
            if error == nil{
                
                Helper.shared.switchStoryboard(storyboardName: "Main", identifier: "home")
            }else{
                
                Helper.shared.showOKAlert(title: "Error", message: (error?.localizedDescription)!, viewController: self)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
