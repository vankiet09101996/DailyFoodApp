//
//  RecentlyViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 20/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher

protocol RecentlyViewControllerDelegate: class {
    func mainSiteViewControllerDidTapMenuButton(_ rootViewController: RecentlyViewController)
}
class RecentlyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var mySearchBar: UISearchBar! {
        didSet{
            self.mySearchBar.delegate = self
        }
    }
    @IBOutlet weak var recentlyTable: UITableView! {
        didSet {
            recentlyTable.delegate = self
            recentlyTable.dataSource = self
        }
    }
    var searching = false
    var recentlyFilter:[DishObj]?
    var recentlyViewedEvens:[DishObj]?
    var allRecentlyViews:[DishObj]?
    var isShowDrawer:Bool = false
    let menuVC = MenuViewController()
    var dishObj:DishObj?
    var mealObjs:[MealObj]?
    //MARK: filter
    var filterObj = FilterObj()
    var isFilter: Bool = false
    var recentlyViewedFilters:[DishObj]?
    var recentlyViewedSearchFilters:[DishObj]?
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
        recentlyViewedEvens = realm.objects(DishObj.self).filter("upDataDate != nil").sorted(byKeyPath: "upDataDate", ascending: false).toArray(ofType: DishObj.self)
        mealObjs = realm.objects(MealObj.self).toArray(ofType: MealObj.self)
        
        //MARK: Filter
        recentlyViewedFilters = realm.objects(DishObj.self).filter("upDataDate != nil && \(query)").sorted(byKeyPath: "upDataDate", ascending: false).toArray(ofType: DishObj.self)
        recentlyTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: NavigationBAR
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        //MARK: DRAWER
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
        recentlyViewedFilters = realm.objects(DishObj.self).filter("upDataDate != nil && \(query)").sorted(byKeyPath: "upDataDate", ascending: false).toArray(ofType: DishObj.self)
        recentlyTable.reloadData()
    }
    
    func loadData() {
        let realm = try! Realm()
        recentlyViewedEvens = realm.objects(DishObj.self).filter("upDataDate != nil").sorted(byKeyPath: "upDataDate", ascending: false).toArray(ofType: DishObj.self)
        recentlyTable.reloadData()
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
                return recentlyFilter!.count
            }
            return recentlyViewedEvens!.count
        } else {
            if searching {
                return recentlyViewedSearchFilters!.count
            }
            return recentlyViewedFilters!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.recentlyTable.dequeueReusableCell(withIdentifier: "RecentlyTableViewCell", for: indexPath) as! RecentlyTableViewCell
        if isFilter == false {
            if searching {
                let recentlyfilter = recentlyFilter![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == recentlyfilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = recentlyfilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = recentlyfilter.name
                cell.caloLabel.text = String(recentlyfilter.calories) + " Calories"
                cell.minLabel.text = String(recentlyfilter.prepareTime) + " mins"
                cell.servingLabel.text = String(recentlyfilter.serving) + " Serving"
                if recentlyfilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recentlyfilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyfilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyfilter.isLiked = false
                        }
                    }
                }
                if recentlyfilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyfilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyfilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyfilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyfilter.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            } else {
                let recentlyViewedEven = recentlyViewedEvens![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == recentlyViewedEven.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = recentlyViewedEven.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = recentlyViewedEven.name
                cell.caloLabel.text = String(recentlyViewedEven.calories) + " Calories"
                cell.minLabel.text = String(recentlyViewedEven.prepareTime) + " mins"
                cell.servingLabel.text = String(recentlyViewedEven.serving) + " Serving"
                if recentlyViewedEven.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recentlyViewedEven.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyViewedEven.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyViewedEven.isLiked = false
                        }
                    }
                }
                if recentlyViewedEven.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedEven.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedEven.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedEven.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedEven.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            }
        } else {
            if searching {
                let recentlyViewedSearchFilter = recentlyViewedSearchFilters![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == recentlyViewedSearchFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = recentlyViewedSearchFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = recentlyViewedSearchFilter.name
                cell.caloLabel.text = String(recentlyViewedSearchFilter.calories) + " Calories"
                cell.minLabel.text = String(recentlyViewedSearchFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(recentlyViewedSearchFilter.serving) + " Serving"
                if recentlyViewedSearchFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recentlyViewedSearchFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyViewedSearchFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyViewedSearchFilter.isLiked = false
                        }
                    }
                }
                if recentlyViewedSearchFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedSearchFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedSearchFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedSearchFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedSearchFilter.rating == 5 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
            } else {
                let recentlyViewedFilter = recentlyViewedFilters![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == recentlyViewedFilter.mealID}
                    cell.mealLabel.text = mealObj?.name
                }
                let urlString = recentlyViewedFilter.urlDish
                cell.foodImage.kf.setImage(with: URL(string: urlString!))
                cell.nameLabel.text = recentlyViewedFilter.name
                cell.caloLabel.text = String(recentlyViewedFilter.calories) + " Calories"
                cell.minLabel.text = String(recentlyViewedFilter.prepareTime) + " mins"
                cell.servingLabel.text = String(recentlyViewedFilter.serving) + " Serving"
                if recentlyViewedFilter.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recentlyViewedFilter.isLiked == false {
                        cell.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyViewedFilter.isLiked = true
                        }
                    } else {
                        cell.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recentlyViewedFilter.isLiked = false
                        }
                    }
                }
                if recentlyViewedFilter.rating == 1 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedFilter.rating == 2 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedFilter.rating == 3 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedFilter.rating == 4 {
                    cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recentlyViewedFilter.rating == 5 {
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
                let selectedItem = recentlyFilter![indexPath.item]
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
                let selectedItem = recentlyViewedEvens![indexPath.item]
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
                let selectedItem = recentlyViewedSearchFilters![indexPath.item]
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
                let selectedItem = recentlyViewedFilters![indexPath.item]
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
extension RecentlyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isFilter == false {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "name contains[cd] %@", searchText)
            recentlyFilter = realm.objects(DishObj.self).filter("upDataDate != nil && \(predicate)").sorted(byKeyPath: "upDataDate", ascending: false).toArray(ofType: DishObj.self)
            searching = true
            recentlyTable.reloadData()
            
            if searchText == "" {
                searching = false
                recentlyFilter = recentlyViewedEvens
                recentlyTable.reloadData()
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
            recentlyViewedSearchFilters = realm.objects(DishObj.self).filter("upDataDate != nil && \(query) && \(predicate)").sorted(byKeyPath: "upDataDate", ascending: false).toArray(ofType: DishObj.self)
            searching = true
            recentlyTable.reloadData()
            
            if searchText == "" {
                searching = false
                recentlyViewedSearchFilters = recentlyViewedFilters
                recentlyTable.reloadData()
            }
        }
    }
}
