//
//  SearchForDishViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 05/07/2021.
//
enum EnumSetupSearch {
    case searchHome, isClearFalse, isClearTrue
}

import UIKit
import RealmSwift
import Kingfisher

class SearchForDishViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mySearchBar: UISearchBar!{
        didSet {
            self.mySearchBar.delegate = self
        }
    }
    @IBOutlet weak var myTable: UITableView! {
        didSet {
            self.myTable.delegate = self
            self.myTable.dataSource = self
            myTable.rowHeight = 109
        }
    }
    //MARK: search for SearchBar Home
    var enumSetupSearch:EnumSetupSearch = EnumSetupSearch.searchHome
    var allFilterObjs :[DishObj]?
    var allFilterSearchObjs:[DishObj]?
    //MARK: Variables
    var mealObjs : [MealObj]?
    var filterObj = FilterObj()
    //MARK: dishObj
    var dishFilter: [DishObj]?
    var dishObjs: [DishObj]?
    var allDishObjs: [DishObj]?
    var allDishObjsSeacrhs:[DishObj]?
    var searching = false
    //MARK: CallBack
    var onFilterShow: ((_ filterObj:FilterObj?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        
        mealObjs = realm.objects(MealObj.self).toArray(ofType: MealObj.self)
        
        var query = ""
        if filterObj.mealID != nil {
            query += "mealID == \(filterObj.mealID ?? 0)"
        } else {
            query += "mealID != 0"
        }
        
        if  filterObj.courseID != nil {
            query += " && courseID == \(filterObj.courseID ?? 0)"
        } else {
            query += "&& courseID != 0"
        }
        
        if filterObj.serving != nil {
            query += " && serving == \(filterObj.serving ?? 0)"
        } else if filterObj.serving == nil {
            query += "&& serving != 0"
        }
        
        if filterObj.prepareTime != nil {
            query += " && prepareTime <= \(filterObj.prepareTime ?? 0)"
        } else if filterObj.prepareTime == nil {
            query += "&& prepareTime != 0"
        }
        
        if filterObj.calories != nil {
            query += " && calories <= \(filterObj.calories ?? 0)"
        } else if filterObj.calories == nil {
            query += "&& calories != 0"
        }
        
        dishObjs = realm.objects(DishObj.self).filter(query).toArray(ofType: DishObj.self)
        allDishObjs = realm.objects(DishObj.self).toArray(ofType: DishObj.self)
        myTable.reloadData()
    }
    
    func loadDataFilter() {
        let realm = try! Realm()
        
        var query = ""
        if filterObj.mealID != nil {
            query += "mealID == \(filterObj.mealID ?? 0)"
        } else {
            query += "mealID != 0"
        }
        
        if  filterObj.courseID != nil {
            query += " && courseID == \(filterObj.courseID ?? 0)"
        } else {
            query += "&& courseID != 0"
        }
        
        if filterObj.serving != nil {
            query += " && serving == \(filterObj.serving ?? 0)"
        } else if filterObj.serving == nil {
            query += "&& serving != 0"
        }
        
        if filterObj.prepareTime != nil {
            query += " && prepareTime <= \(filterObj.prepareTime ?? 0)"
        } else if filterObj.prepareTime == nil {
            query += "&& prepareTime != 0"
        }
        
        if filterObj.calories != nil {
            query += " && calories <= \(filterObj.calories ?? 0)"
        } else if filterObj.calories == nil {
            query += "&& calories != 0"
        }
        dishObjs = realm.objects(DishObj.self).filter(query).toArray(ofType: DishObj.self)
        myTable.reloadData()
    }
    
    func loadData() {
        let realm = try! Realm()
        allDishObjs = realm.objects(DishObj.self).toArray(ofType: DishObj.self)
        myTable.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enumSetupSearch {

        case .searchHome:
            if searching {
                return allFilterSearchObjs?.count ?? 0
            } else {
                return allFilterObjs?.count ?? 0
            }
        case .isClearFalse:
            if searching {
                return dishFilter!.count
            } else {
                return dishObjs!.count
            }
        case .isClearTrue:
            if searching {
                return allDishObjsSeacrhs?.count ?? 0
            } else {
                return allDishObjs?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCell(withIdentifier: "SearchForDishFooterTableViewCell", for: indexPath) as! SearchForDishFooterTableViewCell
        
        switch enumSetupSearch {

        case .searchHome:
            if searching {
                let allFilterSearchObj = allFilterSearchObjs![indexPath.row]
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == allFilterSearchObj.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = allFilterSearchObj.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = allFilterSearchObj.name
                cell.caloLabel.text = String(allFilterSearchObj.calories) + " Calories"
                cell.minLabel.text = String(allFilterSearchObj.prepareTime) + " mins"
                cell.servingLabel.text = String(allFilterSearchObj.serving) + " Serving"
                
                if allFilterSearchObj.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if allFilterSearchObj.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allFilterSearchObj.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allFilterSearchObj.isLiked = false
                        }
                    }
                }
                
                if allFilterSearchObj.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterSearchObj.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterSearchObj.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterSearchObj.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterSearchObj.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            } else {
                let allFilterObj = allFilterObjs![indexPath.row]
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == allFilterObj.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = allFilterObj.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = allFilterObj.name
                cell.caloLabel.text = String(allFilterObj.calories) + " Calories"
                cell.minLabel.text = String(allFilterObj.prepareTime) + " mins"
                cell.servingLabel.text = String(allFilterObj.serving) + " Serving"
                
                if allFilterObj.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if allFilterObj.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allFilterObj.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allFilterObj.isLiked = false
                        }
                    }
                }
                
                if allFilterObj.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterObj.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterObj.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterObj.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allFilterObj.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            }
            
        case .isClearFalse:
            if searching {
                let dishsFilter = dishFilter![indexPath.row]
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == dishsFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = dishsFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = dishsFilter.name
                cell.caloLabel.text = String(dishsFilter.calories) + " Calories"
                cell.minLabel.text = String(dishsFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(dishsFilter.serving) + " Serving"
                
                if dishsFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if dishsFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            dishsFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            dishsFilter.isLiked = false
                        }
                    }
                }
                
                if dishsFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishsFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishsFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishsFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishsFilter.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            } else {
                let dishObj = dishObjs![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == dishObj.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = dishObj.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = dishObj.name
                cell.caloLabel.text = String(dishObj.calories) + " Calories"
                cell.minLabel.text = String(dishObj.prepareTime) + " mins"
                cell.servingLabel.text = String(dishObj.serving) + " Serving"
                
                if dishObj.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if dishObj.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            dishObj.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            dishObj.isLiked = false
                        }
                    }
                }
                if dishObj.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            }
        case .isClearTrue:
            if searching {
                let allDishObjsSeacrh = allDishObjsSeacrhs![indexPath.row]
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == allDishObjsSeacrh.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = allDishObjsSeacrh.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = allDishObjsSeacrh.name
                cell.caloLabel.text = String(allDishObjsSeacrh.calories) + " Calories"
                cell.minLabel.text = String(allDishObjsSeacrh.prepareTime) + " mins"
                cell.servingLabel.text = String(allDishObjsSeacrh.serving) + " Serving"
                
                if allDishObjsSeacrh.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if allDishObjsSeacrh.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allDishObjsSeacrh.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allDishObjsSeacrh.isLiked = false
                        }
                    }
                }
                
                if allDishObjsSeacrh.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObjsSeacrh.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObjsSeacrh.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObjsSeacrh.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObjsSeacrh.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            } else {
                let allDishObj = allDishObjs![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == allDishObj.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = allDishObj.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = allDishObj.name
                cell.caloLabel.text = String(allDishObj.calories) + " Calories"
                cell.minLabel.text = String(allDishObj.prepareTime) + " mins"
                cell.servingLabel.text = String(allDishObj.serving) + " Serving"
                
                if allDishObj.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if allDishObj.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allDishObj.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allDishObj.isLiked = false
                        }
                    }
                }
                if allDishObj.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObj.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObj.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObj.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allDishObj.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            }
        }
        return cell
    }
    
    //MARK: Detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch enumSetupSearch {

        case .searchHome:
            if searching {
                let selectedItem = allFilterSearchObjs![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                let realm = try! Realm()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            } else {
                let selectedItem = allFilterObjs![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                let realm = try! Realm()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            }
        case .isClearFalse:
            if searching {
                let selectedItem = dishFilter![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                let realm = try! Realm()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            } else {
                let selectedItem = dishObjs![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                let realm = try! Realm()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            }
        case .isClearTrue:
            if searching {
                let selectedItem = allDishObjsSeacrhs![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                let realm = try! Realm()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            } else {
                let selectedItem = allDishObjs![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                let realm = try! Realm()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            }
        }
    }

    @IBAction func onClear(_ sender: Any) {
        searching = false
        enumSetupSearch = .isClearTrue
        mySearchBar.text = ""
        loadData()
    }

    @IBAction func onFilter(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.onFilterShow?(self.filterObj)
        print(filterObj)
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
//MARK: Search Bar Config
extension SearchForDishViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch enumSetupSearch {

        case .searchHome:
            let realm = try! Realm()
//            let predicate = NSPredicate(format: "name contains[cd] %@", searchText)
            allFilterSearchObjs = realm.objects(DishObj.self).filter("name contains[cd] '\(searchText)'").toArray(ofType: DishObj.self)
            searching = true
            myTable.reloadData()
            
            if searchText == "" {
                searching = false
                allFilterSearchObjs = allFilterObjs
                myTable.reloadData()
            }
            
        case .isClearFalse:
            var query = ""
            if filterObj.mealID != nil {
                query += "mealID == \(filterObj.mealID ?? 0)"
            } else {
                query += "mealID != 0"
            }
            
            if  filterObj.courseID != nil {
                query += " && courseID == \(filterObj.courseID ?? 0)"
            } else {
                query += "&& courseID != 0"
            }
            
            if filterObj.serving != nil {
                query += " && serving == \(filterObj.serving ?? 0)"
            } else if filterObj.serving == nil {
                query += "&& serving != 0"
            }
            
            if filterObj.prepareTime != nil {
                query += " && prepareTime <= \(filterObj.prepareTime ?? 0)"
            } else if filterObj.prepareTime == nil {
                query += "&& prepareTime != 0"
            }
            
            if filterObj.calories != nil {
                query += " && calories <= \(filterObj.calories ?? 0)"
            } else if filterObj.calories == nil {
                query += "&& calories != 0"
            }
            let realm = try! Realm()
            let predicate = NSPredicate(format: "name contains[cd] %@", searchText)
            dishFilter = realm.objects(DishObj.self).filter("\(query) && \(predicate)").toArray(ofType: DishObj.self)
            searching = true
            myTable.reloadData()
            
            if searchText == "" {
                searching = false
                dishFilter = dishObjs
                myTable.reloadData()
            }
        case .isClearTrue:
            let realm = try! Realm()
            let predicate = NSPredicate(format: "name contains[cd] %@", searchText)
            allDishObjsSeacrhs = realm.objects(DishObj.self).filter(predicate).toArray(ofType: DishObj.self)
            searching = true
            myTable.reloadData()
            
            if searchText == "" {
                searching = false
                allDishObjsSeacrhs = allDishObjs
                myTable.reloadData()
            }
        }
    }
}
