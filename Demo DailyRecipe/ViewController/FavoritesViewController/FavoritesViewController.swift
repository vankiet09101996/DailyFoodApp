//
//  FavoritesViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 20/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher
protocol FavoritesViewControllerDelegate: class {
    func mainSiteViewControllerDidTapMenuButton(_ rootViewController: FavoritesViewController)
}
class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var mySearchBar: UISearchBar!{
        didSet {
            self.mySearchBar.delegate = self
        }
    }
    @IBOutlet weak var favoritesTable: UITableView!
    //MARK: Variables
    var isLiked: Bool = true
    var isShowDrawer:Bool = false
    var favoritesFilter:[DishObj]?
    var favoritesObjs:[DishObj]?
    var mealObjs:[MealObj]?
    let menuVC = MenuViewController()
    var searching = false
    var realm: Realm!
    
    //MARK: filter
    var favoritesObjsFilters:[DishObj]?
    var filterObj = FilterObj()
    var favoritesFilterSearchs:[DishObj]?
    var isFilter: Bool = false
    
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
        
        
        favoritesObjs = realm.objects(DishObj.self).filter("isLiked == \(isLiked)").toArray(ofType: DishObj.self)
        mealObjs = realm.objects(MealObj.self).toArray(ofType: MealObj.self)
        favoritesObjsFilters = realm.objects(DishObj.self).filter("isLiked == true && \(query)").toArray(ofType: DishObj.self)
        self.favoritesTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        favoritesTable.rowHeight = 99
        //MARK: NavigationBAR
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        //MARK: Drawer
        menuVC.view.backgroundColor = .white
        let size = UIScreen.main.bounds.size
        menuVC.view.frame = CGRect(x: -size.width, y: 0, width: size.width, height: self.view.bounds.height)
        UIApplication.shared.keyWindow!.addSubview(menuVC.view)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender: )))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
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
        favoritesObjsFilters = realm.objects(DishObj.self).filter("isLiked == true && \(query)").toArray(ofType: DishObj.self)
        favoritesTable.reloadData()
    }
    
    func loadData() {
        let realm = try! Realm()
        favoritesObjs = realm.objects(DishObj.self).filter("isLiked == \(isLiked)").toArray(ofType: DishObj.self)
        favoritesTable.reloadData()
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
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter == false {
            if searching {
                return favoritesFilter!.count
            }
            return favoritesObjs!.count
        } else {
            if searching {
                return favoritesFilterSearchs!.count
            }
            return favoritesObjsFilters!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favoritesTable.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        if isFilter == false {
            if searching {
                let favoritesFilters = favoritesFilter![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == favoritesFilters.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = favoritesFilters.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = favoritesFilters.name
                cell.caloLabel.text = String(favoritesFilters.calories) + " Calories"
                cell.minLabel.text = String(favoritesFilters.prepareTime) + " mins"
                cell.servingLabel.text = String(favoritesFilters.serving) + " Serving"
                if favoritesFilters.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if favoritesFilters.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesFilters.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesFilters.isLiked = false
                            self.favoritesFilter?.remove(at: indexPath.row)
                            self.favoritesTable.reloadData()
                        }
                    }
                }
                if favoritesFilters.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilters.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilters.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilters.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilters.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                
                
            } else {
                let favoritesObj = favoritesObjs![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == favoritesObj.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = favoritesObj.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = favoritesObj.name
                cell.caloLabel.text = String(favoritesObj.calories) + " Calories"
                cell.minLabel.text = String(favoritesObj.prepareTime) + " mins"
                cell.servingLabel.text = String(favoritesObj.serving) + " Serving"
                if favoritesObj.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if favoritesObj.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesObj.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesObj.isLiked = false
                            self.favoritesObjs?.remove(at: indexPath.row)
                            self.favoritesFilter?.remove(at: indexPath.row)
                        }
                        self.favoritesTable.reloadData()
                    }
                }
                if favoritesObj.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObj.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObj.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObj.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObj.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            }
        } else {
            if searching {
                let favoritesFilterSearch = favoritesFilterSearchs![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == favoritesFilterSearch.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = favoritesFilterSearch.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = favoritesFilterSearch.name
                cell.caloLabel.text = String(favoritesFilterSearch.calories) + " Calories"
                cell.minLabel.text = String(favoritesFilterSearch.prepareTime) + " mins"
                cell.servingLabel.text = String(favoritesFilterSearch.serving) + " Serving"
                if favoritesFilterSearch.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if favoritesFilterSearch.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesFilterSearch.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesFilterSearch.isLiked = false
                            self.favoritesFilter?.remove(at: indexPath.row)
                            self.favoritesTable.reloadData()
                        }
                    }
                }
                if favoritesFilterSearch.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilterSearch.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilterSearch.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilterSearch.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesFilterSearch.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                
                
            } else {
                let favoritesObjsFilter = favoritesObjsFilters![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == favoritesObjsFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = favoritesObjsFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = favoritesObjsFilter.name
                cell.caloLabel.text = String(favoritesObjsFilter.calories) + " Calories"
                cell.minLabel.text = String(favoritesObjsFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(favoritesObjsFilter.serving) + " Serving"
                if favoritesObjsFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if favoritesObjsFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesObjsFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            favoritesObjsFilter.isLiked = false
                            self.favoritesObjs?.remove(at: indexPath.row)
                            self.favoritesFilter?.remove(at: indexPath.row)
                        }
                        self.favoritesTable.reloadData()
                    }
                }
                if favoritesObjsFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObjsFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObjsFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObjsFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if favoritesObjsFilter.rating == 5 {
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
        if isFilter == false {
            if searching {
                let selectedItem = favoritesFilter![indexPath.item]
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
                let selectedItem = favoritesObjs![indexPath.item]
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
                let selectedItem = favoritesFilterSearchs![indexPath.item]
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
                let selectedItem = favoritesObjsFilters![indexPath.item]
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
    
    
    
    
    
    
    
    
    
    //MARK: Drawer
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        let size = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.4, animations: {[weak self] in
            guard let self = self else { return }
            self.isShowDrawer = true
            self.menuVC.view.frame = CGRect(x: 0, y: 0, width: size.width, height: self.view.bounds.height)
        })
    }
    
    @IBAction func onDrawer(_ sender: Any) {
        let size = UIScreen.main.bounds.size
        if !isShowDrawer  {
            UIView.animate(withDuration: 0.4, animations: {[weak self] in
                guard let self = self else { return }
                self.isShowDrawer = true
                self.menuVC.view.frame = CGRect(x: 0, y: 0, width: size.width, height: self.view.bounds.height)
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {[weak self] in
                guard let self = self else { return }
                self.isShowDrawer = false
                self.menuVC.view.frame = CGRect(x: -size.width, y: 0, width: size.width, height: self.view.bounds.height)
            })
        }
    }
    @IBAction func onFilter(_ sender: Any) {
        onShowFilterPopup()
    }
    @IBAction func onClear(_ sender: Any) {
        searching = false
        isFilter = false
        mySearchBar.text = ""
        self.loadData()
    }
}
extension FavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        favoritesFilter = favoritesObjs!.filter({$0.name?.first!.lowercased() == searchText.first?.lowercased()})
        if isFilter == false {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "name contains[cd] %@", searchText)
            favoritesFilter = realm.objects(DishObj.self).filter("isLiked == true && \(predicate)").toArray(ofType: DishObj.self)
            searching = true
            favoritesTable.reloadData()
            
            if searchText == "" {
                searching = false
                favoritesFilter = favoritesObjs
                favoritesTable.reloadData()
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
            let realm = try! Realm()
            let predicate = NSPredicate(format: "name contains[c] %@", searchText)
            favoritesFilterSearchs = realm.objects(DishObj.self).filter("isLiked == true && \(query) && \(predicate)").toArray(ofType: DishObj.self)
            searching = true
            favoritesTable.reloadData()
            
            if searchText == "" {
                searching = false
                favoritesFilterSearchs = favoritesObjsFilters
                favoritesTable.reloadData()
            }
        }
    }
}
