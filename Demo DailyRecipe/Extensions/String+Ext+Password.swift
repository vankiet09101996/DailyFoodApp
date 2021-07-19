//
//  String+Ext+Password.swift
//  NewSentinel DemoSignUp
//
//  Created by NEM on 03/06/2021.
//

import Foundation
extension String {
    public func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
