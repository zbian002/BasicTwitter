//
//  ViewController.swift
//  BasicTwitter
//
//  Created by Zhen Bian on 07/10/2017.
//  Copyright © 2017年 Zhen Bian. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var messages = [PFObject]()
    var selectedObjectFromHome: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = PFUser.current()?.username
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMessages()
    }
    
    func getMessages() {
        let query = PFQuery(className: "Messages")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects, error) in
            if let objects = objects {
                print(objects[0])
                self.messages = objects
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to logout?", message: "Click cancel to remain in the app", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            PFUser.logOut()
            Helper.shared.switchStoryboard(storyboardName: "Login", identifier: "login")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comments"{
            let destVC = segue.destination as! CommentsViewController
            if let selectedObjFromHome = selectedObjectFromHome {
                destVC.selectedObject = selectedObjFromHome
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessagesTableViewCell
        let messageObj = messages[indexPath.row]
        let sender = messageObj["sender"] as? String ?? ""
        let message = messageObj["message"] as? String ?? ""
        let comments = messageObj["comments"] as? [String] ?? [String]()
        let likes = messageObj["likes"] as? [String] ?? [String]()
        cell.usernameLabel.text = sender
        cell.messageLabel.text = message
        cell.commentButton.setTitle("\(comments.count) comments", for: .normal)
        cell.likeButton.setTitle("\(likes.count) likes", for: .normal)
        //set up like button click
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeClicked(sender:)), for: .touchUpInside)
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(commentClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    @objc func likeClicked(sender: UIButton) {
        let messageObj = messages[sender.tag]
        let currentUsername = PFUser.current()?.username!
        let sender = messageObj["sender"] as? String ?? ""
        var likesArray = messageObj["likes"] as? [String] ?? [String]()
        if sender == currentUsername {
            Helper.shared.showOKAlert(title: "Not allowed", message: "You are now allowed to like your own messages", viewController: self)
            return
        }
        if likesArray.contains(currentUsername!) {
            Helper.shared.showOKAlert(title: "Not Allowed", message: "You cannot like a message multiple times.", viewController: self)
            return
        }
        likesArray.append(currentUsername!)
        messageObj["likes"] = likesArray
        messageObj.addUniqueObject(currentUsername!, forKey: "likes")
        messageObj.saveInBackground { (succeed, error) in
            self.tableView.reloadData()
        }
    }
    
    @objc func commentClicked(sender: UIButton) {
        print(sender.tag)
        selectedObjectFromHome = messages[sender.tag]
        performSegue(withIdentifier: "comments", sender: self)
    }
}


