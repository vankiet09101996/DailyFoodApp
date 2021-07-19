//
//  ViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 22/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher

class SeeAllTodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mySearchBar: UISearchBar!{
        didSet {
            self.mySearchBar.delegate = self
        }
    }
    @IBOutlet weak var myTable: UITableView! {
        didSet{
            self.myTable.delegate = self
            self.myTable.dataSource = self
        }
    }
    //MARK: Variables
    var searching = false
    var toDayFilter:[DishObj]?
    var alltodayEvent: [DishObj]?
    var mealObjs : [MealObj]?
    //MARK: filter
    var toDayObjsFilters:[DishObj]?
    var filterObj = FilterObj()
    var toDaySearchsFilters:[DishObj]?
    var isFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        resultDay = date.convertToString()
        
        
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
        toDayObjsFilters = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)' && \(query)").toArray(ofType: DishObj.self)
        self.myTable.reloadData()
    }
    
    func loadDataFilter() {
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        resultDay = date.convertToString()
        
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
        toDayObjsFilters = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)' && \(query)").toArray(ofType: DishObj.self)
        myTable.reloadData()
    }
    
    func loadData() {
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        resultDay = date.convertToString()
        alltodayEvent = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)'").toArray(ofType: DishObj.self)
        myTable.reloadData()
    }
    //MARK: FILLTER VC
    func onShowFilterPopup()  {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = sb.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
        filterVC.onDishFilter = { filterObj in
            self.filterObj = filterObj!
            self.isFilter = true
            self.loadDataFilter()
            print("mealID == \(filterObj?.mealID ?? 0) courseID == \(filterObj?.courseID ?? 0)")
            
            if (filterObj?.mealID == nil) && (filterObj?.courseID == nil) && (filterObj?.calories == nil) {
                self.isFilter = false
                self.loadData()
            }
        }
        filterVC.filterObj = filterObj
        self.present(filterVC, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter == false {
            if searching {
                return toDayFilter!.count
            } else {
                return alltodayEvent!.count
            }
        } else {
            if searching {
                return toDaySearchsFilters!.count
            } else {
                return toDayObjsFilters!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCell(withIdentifier: "SeeAllTodayTableViewCell", for: indexPath) as! SeeAllTodayTableViewCell
        if isFilter == false {
            if searching {
                let toDayFilters = toDayFilter![indexPath.row]
                
                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == toDayFilters.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = toDayFilters.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                
                cell.nameLabel.text = toDayFilters.name
                cell.caloLabel.text = String(toDayFilters.calories) + " Calories"
                cell.minLabel.text = String(toDayFilters.prepareTime) + " mins"
                cell.servingLabel.text = String(toDayFilters.serving) + " Serving"
                
                if toDayFilters.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if toDayFilters.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            toDayFilters.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            toDayFilters.isLiked = false
                        }
                    }
                }
                if toDayFilters.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayFilters.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayFilters.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayFilters.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayFilters.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                return cell
            } else {
                let allTodayEvents = alltodayEvent![indexPath.row]
                
                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == allTodayEvents.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = allTodayEvents.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                
                cell.nameLabel.text = allTodayEvents.name
                cell.caloLabel.text = String(allTodayEvents.calories) + " Calories"
                cell.minLabel.text = String(allTodayEvents.prepareTime) + " mins"
                cell.servingLabel.text = String(allTodayEvents.serving) + " Serving"
                
                if allTodayEvents.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if allTodayEvents.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allTodayEvents.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            allTodayEvents.isLiked = false
                        }
                    }
                }
                if allTodayEvents.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allTodayEvents.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allTodayEvents.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allTodayEvents.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if allTodayEvents.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            }
        } else {
            if searching {
                let toDaySearchsFilter = toDaySearchsFilters![indexPath.row]

                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == toDaySearchsFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = toDaySearchsFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                
                cell.nameLabel.text = toDaySearchsFilter.name
                cell.caloLabel.text = String(toDaySearchsFilter.calories) + " Calories"
                cell.minLabel.text = String(toDaySearchsFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(toDaySearchsFilter.serving) + " Serving"
                
                if toDaySearchsFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if toDaySearchsFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            toDaySearchsFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            toDaySearchsFilter.isLiked = false
                        }
                    }
                }
                if toDaySearchsFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDaySearchsFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDaySearchsFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDaySearchsFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDaySearchsFilter.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                return cell
            } else {
                let toDayObjsFilter = toDayObjsFilters![indexPath.row]

                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == toDayObjsFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = toDayObjsFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                
                cell.nameLabel.text = toDayObjsFilter.name
                cell.caloLabel.text = String(toDayObjsFilter.calories) + " Calories"
                cell.minLabel.text = String(toDayObjsFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(toDayObjsFilter.serving) + " Serving"
                
                if toDayObjsFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if toDayObjsFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            toDayObjsFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            toDayObjsFilter.isLiked = false
                        }
                    }
                }
                if toDayObjsFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayObjsFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayObjsFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayObjsFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if toDayObjsFilter.rating == 5 {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFilter == false {
            if searching {
                let selectedItem = toDayFilter![indexPath.item]
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
                let selectedItem = alltodayEvent![indexPath.item]
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
        } else {
            if searching {
                let selectedItem = toDaySearchsFilters![indexPath.item]
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
                let selectedItem = toDayObjsFilters![indexPath.item]
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
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClear(_ sender: Any) {
        searching = false
        isFilter = false
        mySearchBar.text = ""
        self.loadData()
    }
    @IBAction func onFilter(_ sender: Any) {
        onShowFilterPopup()
    }
}

extension SeeAllTodayViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        toDayFilter = alltodayEvent!.filter({$0.name?.first!.lowercased() == searchText.first?.lowercased()})
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        resultDay = date.convertToString()
        if isFilter == false {
            let predicate = NSPredicate(format: "name contains[cd] %@", searchText)
            toDayFilter = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)' && \(predicate)").toArray(ofType: DishObj.self)
            searching = true
            myTable.reloadData()
            
            if searchText == "" {
                searching = false
                toDayFilter = alltodayEvent
                myTable.reloadData()
            }
        } else {
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
            let predicate = NSPredicate(format: "name contains[c] %@", searchText)
            toDaySearchsFilters = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)' && \(query) && \(predicate)").toArray(ofType: DishObj.self)
            searching = true
            myTable.reloadData()
            
            if searchText == "" {
                searching = false
                toDaySearchsFilters = toDayObjsFilters
                myTable.reloadData()
            }
        }
    }
}
