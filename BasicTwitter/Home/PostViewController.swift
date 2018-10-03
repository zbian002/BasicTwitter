//
//  PostViewController.swift
//  BasicTwitter
//
//  Created by Zhen Bian on 07/10/2017.
//  Copyright © 2017年 Zhen Bian. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController {
    @IBOutlet weak var messageTextview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextview.becomeFirstResponder()
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        if messageTextview.text.count == 0 {
            Helper.shared.showOKAlert(title: "Required", message: "Please type some message in order to continue", viewController: self)
            return
        }
        let messageObj = PFObject(className: "Messages")
        messageObj["sender"] = PFUser.current()?.username!
        messageObj["message"] = messageTextview.text
        messageObj["likes"] = [String]()
        messageObj["comments"] = [String]()
        messageObj["flagged"] = 0
        messageObj.saveInBackground { (succeed, error) in
            self.messageTextview.text = ""
            Helper.shared.showOKAlert(title: "Shared", message: "Your message was shared successfully", viewController: self)
        }
    }
}
