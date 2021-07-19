//
//  ViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 22/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher

class SeeAllRecommendedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mySearchBar: UISearchBar! {
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
    var recomemendedFilter:[DishObj]?
    var seeAllRecomemendedEvent:[DishObj]?
    var mealObjs:[MealObj]?
    //MARK:Filter
    var recomemendedObjsFilters:[DishObj]?
    var filterObj = FilterObj()
    var recomemendedSearchsFilters:[DishObj]?
    var isFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        recomemendedObjsFilters = realm.objects(DishObj.self).filter(query).sorted(byKeyPath: "createDate", ascending: false).toArray(ofType: DishObj.self)
        self.myTable.reloadData()
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
        recomemendedObjsFilters = realm.objects(DishObj.self).filter(query).sorted(byKeyPath: "createDate", ascending: false).toArray(ofType: DishObj.self)
        myTable.reloadData()
    }
    
    func loadData() {
        let realm = try! Realm()
        seeAllRecomemendedEvent = realm.objects(DishObj.self).sorted(byKeyPath: "createDate", ascending: false).toArray(ofType: DishObj.self)
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
                return recomemendedFilter?.count ?? 0
            } else {
                return seeAllRecomemendedEvent!.count
            }
        } else {
            if searching {
                return recomemendedSearchsFilters!.count
            } else {
                return recomemendedObjsFilters!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCell(withIdentifier: "SeeAllRecommendedTableViewCell", for: indexPath) as! SeeAllRecommendedTableViewCell
        if isFilter == false {
            if searching {
                let recomemendedFilters = recomemendedFilter![indexPath.row]
                
                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == recomemendedFilters.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                
                let urlString = recomemendedFilters.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = recomemendedFilters.name
                cell.caloLabel.text = String(recomemendedFilters.calories) + " Calories"
                cell.minLabel.text = String(recomemendedFilters.prepareTime) + " mins"
                cell.servingLabel.text = String(recomemendedFilters.serving) + " Serving"
                
                if recomemendedFilters.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recomemendedFilters.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recomemendedFilters.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recomemendedFilters.isLiked = false
                        }
                    }
                }
                if recomemendedFilters.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedFilters.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedFilters.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedFilters.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedFilters.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                
            } else {
                let seeAllRecomemendedEvents = seeAllRecomemendedEvent![indexPath.row]
                
                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == seeAllRecomemendedEvents.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                
                let urlString = seeAllRecomemendedEvents.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = seeAllRecomemendedEvents.name
                cell.caloLabel.text = String(seeAllRecomemendedEvents.calories) + " Calories"
                cell.minLabel.text = String(seeAllRecomemendedEvents.prepareTime) + " mins"
                cell.servingLabel.text = String(seeAllRecomemendedEvents.serving) + " Serving"
                
                if seeAllRecomemendedEvents.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if seeAllRecomemendedEvents.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            seeAllRecomemendedEvents.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            seeAllRecomemendedEvents.isLiked = false
                        }
                    }
                }
                if seeAllRecomemendedEvents.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if seeAllRecomemendedEvents.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if seeAllRecomemendedEvents.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if seeAllRecomemendedEvents.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if seeAllRecomemendedEvents.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            }
        } else {
            if searching {
                let recomemendedSearchsFilter = recomemendedSearchsFilters![indexPath.row]
                
                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == recomemendedSearchsFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                
                let urlString = recomemendedSearchsFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = recomemendedSearchsFilter.name
                cell.caloLabel.text = String(recomemendedSearchsFilter.calories) + " Calories"
                cell.minLabel.text = String(recomemendedSearchsFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(recomemendedSearchsFilter.serving) + " Serving"
                
                if recomemendedSearchsFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recomemendedSearchsFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recomemendedSearchsFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recomemendedSearchsFilter.isLiked = false
                        }
                    }
                }
                if recomemendedSearchsFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedSearchsFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedSearchsFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedSearchsFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedSearchsFilter.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                
            } else {
                let recomemendedObjsFilter = recomemendedObjsFilters![indexPath.row]
                
                if let mealArr = self.mealObjs{
                    let mealObj = mealArr.first { $0.id == recomemendedObjsFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                
                let urlString = recomemendedObjsFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = recomemendedObjsFilter.name
                cell.caloLabel.text = String(recomemendedObjsFilter.calories) + " Calories"
                cell.minLabel.text = String(recomemendedObjsFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(recomemendedObjsFilter.serving) + " Serving"
                
                if recomemendedObjsFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recomemendedObjsFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recomemendedObjsFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recomemendedObjsFilter.isLiked = false
                        }
                    }
                }
                if recomemendedObjsFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedObjsFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedObjsFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedObjsFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recomemendedObjsFilter.rating == 5 {
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
                let selectedItem = recomemendedFilter![indexPath.item]
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
                let selectedItem = seeAllRecomemendedEvent![indexPath.item]
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
                let selectedItem = recomemendedSearchsFilters![indexPath.item]
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
                let selectedItem = recomemendedObjsFilters![indexPath.item]
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
extension SeeAllRecommendedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        recomemendedFilter = seeAllRecomemendedEvent!.filter({$0.name?.first!.lowercased() == searchText.first?.lowercased()})
        let realm = try! Realm()
//        recomemendedFilter = seeAllRecomemendedEvent!.filter({$0.name?.lowercased() == searchText.lowercased()})
        let predicate = NSPredicate(format: "name contains[cd] %@", searchText)
        if isFilter == false {
            recomemendedFilter = realm.objects(DishObj.self).filter(predicate).sorted(byKeyPath: "createDate", ascending: false).toArray(ofType: DishObj.self)
            searching = true
            myTable.reloadData()
            
            if searchText == "" {
                searching = false
                recomemendedFilter = seeAllRecomemendedEvent
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
            recomemendedSearchsFilters = realm.objects(DishObj.self).filter("\(predicate) && \(query)").sorted(byKeyPath: "createDate", ascending: false).toArray(ofType: DishObj.self)
            searching = true
            myTable.reloadData()
            
            if searchText == "" {
                searching = false
                recomemendedSearchsFilters = recomemendedObjsFilters
                myTable.reloadData()
            }
        }
    }
}
