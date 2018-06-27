//
//  SecondViewController.swift
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
class SecondViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var MomentImage: UIImageView!
    
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var libraryImage: UIImageView!
    
    var uuid = NSUUID().uuidString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MomentImage.isUserInteractionEnabled = true
        cameraImage.isUserInteractionEnabled = true
        libraryImage.isUserInteractionEnabled = true
        
        let cameraGesture = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.selectMomentImage))
        cameraImage.addGestureRecognizer(cameraGesture)
        let libraryGesture = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.selectMomentImageFromLibrary))
        libraryImage.addGestureRecognizer(libraryGesture)
       
        
        
    }
    
    @objc func selectMomentImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    MomentImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectMomentImageFromLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }

    @IBAction func UploadClicked(_ sender: Any) {
        let mediaFolder = Storage.storage().reference().child("media")
        
        if let data = UIImageJPEGRepresentation(MomentImage.image!, 0.5) {
            
            mediaFolder.child("\(uuid).jpg").putData(data, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    
                    let post = ["image" : imageURL!, "postedby" : Auth.auth().currentUser!.email!, "uuid" : self.uuid, "posttext" : self.commentText.text] as [String : Any]
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("post").childByAutoId().setValue(post)
                    
                    self.MomentImage.image = UIImage(named: "")
                    self.commentText.text = "Enter your comment here..."
                    
                    
                }
                
            })
            
            
        }
        
    }
    

}

