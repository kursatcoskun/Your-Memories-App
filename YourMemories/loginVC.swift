//
//  loginVC.swift
//  YourMemories
//
//  Created by Kursat Coskun on 5.06.2018.
//  Copyright © 2018 Kursat Coskun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class loginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var imageBack: UIImageView!
    
    var activeTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordText.delegate = self
        usernameText.delegate = self
        self.navigationController?.navigationBar.isHidden = true
    
        usernameText.layer.cornerRadius = 25
        usernameText.clipsToBounds = true
        
        passwordText.layer.cornerRadius = 25
        passwordText.clipsToBounds = true
        
        let center : NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
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
    

    @IBAction func signInButton(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    print(user?.email)
                    self.performSegue(withIdentifier: "loginToMain", sender: nil)
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Kullanıcı Adı ve Şifre Gerekli", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "intoUp", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}
