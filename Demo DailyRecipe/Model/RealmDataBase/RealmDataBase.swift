//
//  RealmDataBase.swift
//  Demo DailyRecipe
//
//  Created by NEM on 17/06/2021.
//

import Foundation
import RealmSwift

class InfomationObj: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func IncrementaID() -> Int{
        let realm = try! Realm()
        return (realm.objects(InfomationObj.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
class DishObj: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var urlDish: String?
    @objc dynamic var mealID: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var courseID: Int = 0
    @objc dynamic var serving = 0
    @objc dynamic var prepareTime = 0
    @objc dynamic var calories = 0
    @objc dynamic var rating = 0
    @objc dynamic var isLiked = false
    @objc dynamic var viewDate : String?
    @objc dynamic var createDate = Date()
    @objc dynamic var descriptions : String?
    @objc dynamic var Ingredients : String?
    @objc dynamic var upDataDate : Date?
    override static func primaryKey() -> String? {
        return "id"
    }
    func IncrementaID() -> Int{
        let realm = try! Realm()
        return (realm.objects(DishObj.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }

}
class MealObj: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name : String?
}


class CourseObj: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name : String?
}

class IngredientsObj: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name : String?
    @objc dynamic var descriptions : String?
}





