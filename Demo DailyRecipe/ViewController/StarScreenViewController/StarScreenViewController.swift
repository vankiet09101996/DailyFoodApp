//
//  ViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 16/06/2021.
//

import UIKit
import RealmSwift
class StarScreenViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        registerButton.layer.cornerRadius = 15
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }

    @IBAction func onResgister(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = sb.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func onSignIn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = sb.instantiateViewController(identifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
}

