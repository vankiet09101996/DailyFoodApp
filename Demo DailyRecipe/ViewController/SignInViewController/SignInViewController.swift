//
//  SignInViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 17/06/2021.
//

import UIKit
import RealmSwift
class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        signInButton.layer.cornerRadius = 15
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray5] )
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray5] )
    }
    
    
    
    
    
    
    @IBAction func onSignIn(_ sender: Any) {
//        guard let email = emailTextField.text, email.count > 0 else {
//            self.showAlert(title: "Error", message: "Please enter your email")
//            return
//        }
//        guard let password = passwordTextField.text, password.count > 0 else {
//            self.showAlert(title: "Error", message: "Please enter your password")
//            return
//        }
//        if !email.isValidEmail() {
//            self.showAlert(title: "Error", message: "Please enter your email in the correct format")
//            return
//        }
//        if !password.isValidPassword() {
//            self.showAlert(title: "Error", message: "Please enter your password in the correct format")
//            return
//        }
//        let realm = try! Realm()
//        let infomationObj = InfomationObj()
//        infomationObj.setValue(email, forKey: "email")
//        infomationObj.setValue(password, forKey: "password")
//
//        let emailResults = realm.objects(InfomationObj.self).filter({ $0.email == self.emailTextField.text}).first
//        let passwordResults = realm.objects(InfomationObj.self).filter({ $0.password == self.passwordTextField.text}).first
//        if emailResults?.email == emailTextField.text, passwordResults?.password == passwordTextField.text {
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//                    let homeVC = sb.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//                    self.navigationController?.pushViewController(homeVC, animated: true)
//
//        }
//        else {
//            self.showAlert(title: "Error", message: "Email or password is incorrect")
//
//        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = sb.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = sb.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}
