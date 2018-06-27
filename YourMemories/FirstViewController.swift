//
//  FirstViewController.swift
//  YourMemories
//
//  Created by Kursat Coskun on 4.06.2018.
//  Copyright © 2018 Kursat Coskun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class FirstViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var userMailArray = [String]()
    var postCommentArray = [String]()
    var postImageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirebase()
    }
    
    func getDataFromFirebase() {
        Database.database().reference().child("users").observe(DataEventType.childAdded) { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            let post = values["post"] as! NSDictionary
            
            let postID = post.allKeys
            
            for id in postID {
                let singleP = post[id] as! NSDictionary
                self.userMailArray.append(singleP["postedby"] as! String)
                self.postCommentArray.append(singleP["posttext"] as! String)
                self.postImageArray.append(singleP["image"] as! String)
            }
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = userMailArray[indexPath.row]
        cell.yorumCell.text = postCommentArray[indexPath.row]
        cell.resimCell.sd_setImage(with: URL(string: self.postImageArray[indexPath.row]))
        
        return cell
    }

}

