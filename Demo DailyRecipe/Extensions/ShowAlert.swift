//
//  ShowAlert+Ext.swift
//  NewSentinel DemoSignUp
//
//  Created by NEM on 03/06/2021.
//

import UIKit

extension UIViewController {
    func showAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
