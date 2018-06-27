//
//  MyProfileVC.swift
//  YourMemories
//
//  Created by Kursat Coskun on 10.06.2018.
//  Copyright © 2018 Kursat Coskun. All rights reserved.
//

import UIKit
import  Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class MyProfileVC: UIViewController {

    
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileNumber: UILabel!
    
    @IBOutlet weak var ProfileEmail: UILabel!
    @IBOutlet weak var ProfileSurname: UILabel!
    @IBOutlet weak var ProfileBday: UILabel!
    
    var userNameArray = [String]()
    var userEmailArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePictureImage.layer.cornerRadius = 20
        profilePictureImage.clipsToBounds = true
        profilePictureImage.layer.borderColor = UIColor.blue.cgColor
        profilePictureImage.layer.borderWidth = 4
        
        getDataFromFirebase()
    }
    
    func getDataFromFirebase(){
        Database.database().reference().child("users").observe(DataEventType.childAdded) { (snapshot) in
            let values = snapshot.value! as! NSDictionary
            let userInfo = values["userInfos"] as! NSDictionary
            let userInfoID = userInfo.allKeys
            for id in userInfoID {
                let singleUser = userInfo[id] as! NSDictionary
                if Auth.auth().currentUser?.email == singleUser["Email"] as! String{
                    self.ProfileName.text = singleUser["name"] as! String
                    self.ProfileSurname.text = singleUser["surname"] as! String
                    self.ProfileEmail.text = singleUser["Email"] as! String
                    self.ProfileNumber.text = singleUser["Phone_Number"] as! String
                    self.ProfileBday.text = singleUser["Birthday"] as! String
                    self.profilePictureImage.sd_setImage(with: URL(string: singleUser["profile_picture"] as! String))
                }
                
               //  self.userNameArray.append(singleUser["name"] as! String)
               // self.userEmailArray.append(singleUser["Email"] as! String)
            }
            
            
        }
    }

    
}
