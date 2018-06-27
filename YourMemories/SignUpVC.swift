//
//  SignUpVC.swift
//  YourMemories
//
//  Created by Kursat Coskun on 7.06.2018.
//  Copyright © 2018 Kursat Coskun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var navbar: UINavigationItem!
    
    
    @IBOutlet weak var ppImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var bdayText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var activeTextField : UITextField!
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameText.delegate = self
        surnameText.delegate = self
        mailText.delegate = self
        numberText.delegate = self
        bdayText.delegate = self
        passwordText.delegate = self
        
        
        nameText.layer.cornerRadius = 25
        nameText.clipsToBounds = true
        surnameText.layer.cornerRadius = 25
        surnameText.clipsToBounds = true
        mailText.layer.cornerRadius = 25
        mailText.clipsToBounds = true
        numberText.layer.cornerRadius = 25
        numberText.clipsToBounds = true
        bdayText.layer.cornerRadius = 25
        bdayText.clipsToBounds = true
        passwordText.layer.cornerRadius = 25
        passwordText.clipsToBounds = true
        
        
        let center : NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.navigationController?.navigationBar.isHidden = false
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.chooseProfilePicture))
        ppImage.addGestureRecognizer(recognizer)
        ppImage.isUserInteractionEnabled = true
    }

    
    
    
    @objc func keyboardDidShow(notification: Notification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        let editingTextFieldY:CGFloat! = self.activeTextField?.frame.origin.y
        
        if self.view.frame.origin.y >= 0 {
            //Checking if the textfield is really hidden behind the keyboard
            if editingTextFieldY > keyboardY - 60 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: self.view.bounds.width,height: self.view.bounds.height)
                }, completion: nil)
            }
        }
        
        
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    @objc func chooseProfilePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    
    @IBAction func backButto(_ sender: Any) {
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        
        
        if mailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!, completion: { (user, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    print(user?.email)
                    
                    
                    
                }
                
                
            })
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Kullanıcı Adı ve Şifre Gerekli", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        
        
        let mediaFolder = Storage.storage().reference().child("media")
        
        if let data = UIImageJPEGRepresentation(ppImage.image!, 0.5) {
            
            mediaFolder.child("\(uuid).jpg").putData(data, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    
                    let userInfos = ["profile_picture" : imageURL!, "uuid" : self.uuid, "name" : self.nameText.text!, "surname" : self.surnameText.text!, "Email" : self.mailText.text!, "Phone_Number" : self.numberText.text!, "Birthday" : self.bdayText.text!] as [String:Any]
                 
                    
                    let post = ["image" : imageURL!, "postedby" : Auth.auth().currentUser!.email!, "uuid" : self.uuid, "posttext" : self.nameText.text!+" isimli kullanıcıya Hoşgeldin demek ister misin ?"] as [String : Any]
                    
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("post").childByAutoId().setValue(post)
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("userInfos").childByAutoId().setValue(userInfos)
                    
                    self.ppImage.image = UIImage(named: "pp.png")
                    self.nameText.text = ""
                    self.surnameText.text = ""
                    self.mailText.text = ""
                    self.numberText.text = ""
                    self.bdayText.text = ""
                    
                }
                
            })
            
            
        }
        
    }
        

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ppImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
