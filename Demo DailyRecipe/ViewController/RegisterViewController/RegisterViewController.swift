//
//  RegisterViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 17/06/2021.
//

import UIKit
import RealmSwift
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        registerButton.layer.cornerRadius = 15
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray5] )
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray5] )
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray5] )
    }
    
    
    
    @IBAction func onResgister(_ sender: Any) {
        guard let name = nameTextField.text, name.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter your name")
            return
        }
        guard let email = emailTextField.text, email.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter your email")
            return
        }
        guard let password = passwordTextField.text, password.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter your password")
            return
        }
        if !email.isValidEmail() {
            self.showAlert(title: "Error", message: "Please enter email in correct format")
            return
        }
        if !password.isValidPassword() {
            self.showAlert(title: "Error", message: "Please enter the password in the correct format")
            return
        }
        let infomationObj = InfomationObj()
        infomationObj.id = infomationObj.IncrementaID()
        infomationObj.setValue(self.nameTextField.text, forKey: "name")
        infomationObj.setValue(self.emailTextField.text, forKey: "email")
        infomationObj.setValue(self.passwordTextField.text, forKey: "password")
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(infomationObj)
                print("Add info ok")
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
            }
        } catch {
            print(error)
        }
        
        
        let defaultAction = UIAlertAction(title: "ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let alert = UIAlertController(title: "successfully",
                                      message: "Sign Up Success",
                                      preferredStyle: .alert)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true) {
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = sb.instantiateViewController(identifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
}
