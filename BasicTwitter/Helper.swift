//
//  Helper.swift
//  BasicTwitter
//
//  Created by Zhen Bian on 07/10/2017.
//  Copyright © 2017年 Zhen Bian. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static let shared = Helper()
    func switchStoryboard(storyboardName: String, identifier: String){
        let sboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = sboard.instantiateViewController(withIdentifier: identifier)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
    
    func showOKAlert(title: String, message: String, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true)
        return
    }
}
