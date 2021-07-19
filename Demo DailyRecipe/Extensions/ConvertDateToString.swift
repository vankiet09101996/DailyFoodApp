//
//  ConvertDateToString.swift
//  Demo DailyRecipe
//
//  Created by NEM on 28/06/2021.
//

import Foundation
extension Date {
    func convertToString(format:String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        print(self)
        return dateFormatter.string(from: self)
    }
}
