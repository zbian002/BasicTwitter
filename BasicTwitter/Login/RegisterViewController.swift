//
//  RegisterViewController.swift
//  BasicTwitter
//
//  Created by Zhen Bian on 07/10/2017.
//  Copyright © 2017年 Zhen Bian. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func register(_ sender: Any) {
        guard let username = usernameTf.text, let password = passwordTf.text else { return }
        let user = PFUser()
        user.username = username.lowercased()
        user.password = password
        user.signUpInBackground { (succeed, error) in
            if succeed == true {
                Helper.shared.switchStoryboard(storyboardName: "Main", identifier: "home")
            }
            else {
                let localised = (error?.localizedDescription)!
                Helper.shared.showOKAlert(title: "Error", message: localised, viewController: self)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
