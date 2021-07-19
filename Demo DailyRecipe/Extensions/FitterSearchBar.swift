//
//  FitterSearchBar.swift
//  Demo DailyRecipe
//
//  Created by NEM on 23/06/2021.
//

import UIKit
class FilterSearch : NSObject {
    var foodMeal: String = ""
    var foodCourse: String = ""
    var foodServing: String = ""
    var foodMin : String = ""
    var foodCalo : String = ""
    
    init(meal: String, course: String, serving: String, min: String, calo: String) {
        self.foodMeal = meal
        self.foodCourse = course
        self.foodServing = serving
        self.foodMin = min
        self.foodCalo = calo
    }
    class func generateFilterArray() -> [FilterSearch] {
        var filterArray = [FilterSearch]()
        filterArray.append(FilterSearch(meal: <#T##String#>, course: <#T##String#>, serving: <#T##String#>, min: <#T##String#>, calo: <#T##String#>))
    }
    
}


