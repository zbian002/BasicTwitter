//
//  CommentsViewController.swift
//  BasicTwitter
//
//  Created by Zhen Bian on 07/10/2017.
//  Copyright © 2017年 Zhen Bian. All rights reserved.
//

import UIKit
import Parse

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentTf: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedObject:PFObject?
    var commentsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        commentsArray = selectedObject?["comments"] as? [String] ?? [String]()
    }

    @IBAction func comment(_ sender: Any) {
        
        if commentTf.text?.characters.count == 0{
            
            Helper.shared.showOKAlert(title: "Error", message: "Please type some comments to continue", viewController: self)
            
            return
        }
        
        let comment = commentTf.text!
        selectedObject?.add(comment, forKey: "comments")
        selectedObject?.saveInBackground(block: { (succeed, error) in
            
            if succeed{
                
                self.commentsArray.append(comment)
                self.commentTf.text = ""
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func flag(_ sender: Any) {
        
        if let selectedObject = selectedObject{
            
            selectedObject.incrementKey("flagged")
            selectedObject.saveInBackground()
        }
    }
    
}

extension CommentsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let eachComment = commentsArray[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = eachComment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentsArray.count
    }
}
