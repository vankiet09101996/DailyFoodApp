//
//  HomeViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 17/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher

struct recomemendeds {
    var image: String
    var meal: String
    var name: String
    var star: String
    var Calories: String
    var min: String
    var Serving: String
}



protocol MainSiteViewControllerDelegate: class {
    func mainSiteViewControllerDidTapMenuButton(_ rootViewController: HomeViewController)
}
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var myTable: UITableView! {
        didSet{
            self.myTable.dataSource = self
            self.myTable.delegate = self
            self.myTable.rowHeight = 99
            self.myTable.reloadData()
        }
    }
    var realm: Realm!
    var dishObjs : [DishObj]?
    var RecommendedEvent: [DishObj]?
    var alltodayEvent : [DishObj]?
    var sortedArray : [DishObj]?
    var mealObjs : [MealObj]?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        resultDay = date.convertToString()
        alltodayEvent = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)'").toArray(ofType: DishObj.self)
        let todayEvent = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)'").first
        RecommendedEvent = realm.objects(DishObj.self).filter("serving == \(todayEvent?.serving ?? 0) || calories == \(todayEvent?.calories ?? 0) || prepareTime == \(todayEvent?.prepareTime ?? 0)").toArray(ofType: DishObj.self)
        sortedArray = realm.objects(DishObj.self).sorted(byKeyPath: "createDate", ascending: false).toArray(ofType: DishObj.self)
        //MARK: Meal ID
        dishObjs = realm.objects(DishObj.self).toArray(ofType: DishObj.self)
        
        
        mealObjs = realm.objects(MealObj.self).toArray(ofType: MealObj.self)
        
        
        myTable.reloadData()
    }
    
    
    let menuVC = MenuViewController()
    var isShowDrawer:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        //MARK: NavigationBAR
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
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
    
    //MARK: Swipe
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        let size = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.4, animations: {[weak self] in
            guard let self = self else { return }
            self.isShowDrawer = true
            self.menuVC.view.frame = CGRect(x: 0, y: 0, width: size.width, height: self.view.bounds.height)
        })
    }
    
    //MARK: Drawer
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
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return 130
            }
        case 1:
            if (indexPath.row == 0) {
                return 230
            }
        case 2:
            return 109
        default:
            break
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            //MARK: return 10 phần tử creatDate giảm dần
            if (alltodayEvent?.count == 0) {
                let first10sortedArray = sortedArray!.count > 10 ? 10 : sortedArray!.count
                return first10sortedArray
            }
            //MARK: lọc theo các tiêu chí của món ăn đầu tiên của today, tiêu chí là bằng serving, chỉ lấy 10 phần tử của dish
            let first10RecommendedEvent = RecommendedEvent?.prefix(10)
            return first10RecommendedEvent?.count ?? 0
        default:
            return 0
        }
    }
    
    func onShowFilterPopup()  {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = sb.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
        filterVC.onDishFilter = onShowSearchPage
        self.present(filterVC, animated: true, completion: nil)
    }
    
    func onShowSearchPage(filterObj: FilterObj?) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = sb.instantiateViewController(identifier: "SearchForDishViewController") as! SearchForDishViewController
        searchVC.onFilterShow = { filterObj in
            if let filterObj = filterObj {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let filterVC = sb.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
                filterVC.filterObj = filterObj
                //MARK: tiếp tục mở popUp và chuyển sang trang search
                filterVC.onDishFilter = { filterObj in
                    searchVC.filterObj = filterObj!
                    searchVC.enumSetupSearch = .isClearFalse
                    searchVC.loadDataFilter()
                }
                
                //show popup
                self.present(filterVC, animated: true, completion: nil)
            }
        }
        //MARK: passData
        searchVC.enumSetupSearch = .isClearFalse
        searchVC.filterObj = filterObj!
        //MARK: navigate
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            if indexPath.row == 0 {
                let cell1 = self.myTable.dequeueReusableCell(withIdentifier: "BonjourTableViewCell", for: indexPath) as! BonjourTableViewCell
                cell1.buttonFilter = onShowFilterPopup
                cell1.searchBarFilter = {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let searchVC = sb.instantiateViewController(identifier: "SearchForDishViewController") as! SearchForDishViewController
//                    searchVC.searching = false
                    searchVC.enumSetupSearch = .searchHome
                    searchVC.allFilterObjs = cell1.allFilterObjs
                    searchVC.onFilterShow = { filterObj in
                        if let filterObj = filterObj {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let filterVC = sb.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
                            filterVC.filterObj = filterObj
                            //MARK: tiếp tục mở popUp và chuyển sang trang search
                            filterVC.onDishFilter = { filterObj in
                                searchVC.filterObj = filterObj!
                                searchVC.enumSetupSearch = .isClearFalse
                                searchVC.loadDataFilter()
                            }
                            
                            //show popup
                            self.present(filterVC, animated: true, completion: nil)
                        }
                    }
//                    searchVC.myTable.reloadData()
                    self.navigationController?.pushViewController(searchVC, animated: true)
                }
                return cell1
            }
        case 1:
            //MARK: Show Detail UICollectionView -> DetailViewController
            if indexPath.row == 0 {
                let cell2 = self.myTable.dequeueReusableCell(withIdentifier: "TodayTableViewCell", for: indexPath) as! TodayTableViewCell
                cell2.onDidSelectItem = { [self](indexPath) in
                    let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                    let selectedItem = self.alltodayEvent![indexPath.item]
                    detaiVC.dishObj = selectedItem
                    //MARK: add Date (ĐÃ XEM)
                    let updatedDate =  Date()
                    try! realm.write {
                        selectedItem.upDataDate = updatedDate
                        detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                    }
                    
                    //MARK: CallBack reload CollectionCell
                    self.navigationController?.pushViewController(detaiVC, animated: true)
                    detaiVC.callBackCell = { dishObjs in
                        detaiVC.dishObj = dishObjs
                        cell2.myCollectionView.reloadData()
                    }
                }
                return cell2
            }
        case 2:
            let cell3 = self.myTable.dequeueReusableCell(withIdentifier: "RecommendedTableViewCell", for: indexPath) as! RecommendedTableViewCell
            if alltodayEvent?.count != 0 {
                let recommendedevent = RecommendedEvent![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == recommendedevent.mealID}
                    cell3.mealLabel.text = mealObj?.name
                }
                let urlString = recommendedevent.urlDish
                cell3.foodImage.kf.setImage(with: URL(string: urlString!))
                cell3.nameLabel.text = recommendedevent.name
                cell3.caloLabel.text = String(recommendedevent.calories) + " Calories"
                cell3.minLabel.text = String(recommendedevent.prepareTime) + " mins"
                cell3.servingLabel.text = String(recommendedevent.serving) + " Serving"
                if recommendedevent.isLiked == false {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell3.buttonIsLikedCallBack = {
                    if recommendedevent.isLiked == false {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! self.realm.write {
                            recommendedevent.isLiked = true
                        }
                    } else {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! self.realm.write {
                            recommendedevent.isLiked = false
                        }
                    }
                }
                if recommendedevent.rating == 1 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedevent.rating == 2 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedevent.rating == 3 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedevent.rating == 4 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedevent.rating == 5 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                
                return cell3
            }
            
            //MARK: Lấy danh sách recommended, Nếu ở phần today không có món ăn nào cả thì lấy 10 phần tử đầu tiên của dish theo điều CreatedDate giảm dần
            
            if (alltodayEvent?.count == 0) {
                let sorted = sortedArray![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == sorted.mealID}
                    cell3.mealLabel.text = mealObj?.name
                }
                
                let urlString = sorted.urlDish
                cell3.foodImage.kf.setImage(with: URL(string: urlString!))
                cell3.nameLabel.text = sorted.name
                cell3.caloLabel.text = String(sorted.calories) + " Calories"
                cell3.minLabel.text = String(sorted.prepareTime) + " mins"
                cell3.servingLabel.text = String(sorted.serving) + " Serving"
                if sorted.isLiked == false {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell3.buttonIsLikedCallBack = {
                    if sorted.isLiked == false {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! self.realm.write {
                            sorted.isLiked = true
                        }
                    } else {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! self.realm.write {
                            sorted.isLiked = false
                        }
                    }
                }
                
                if sorted.rating == 1 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sorted.rating == 2 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sorted.rating == 3 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sorted.rating == 4 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sorted.rating == 5 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                return cell3
            }
            return cell3
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let HeaderToday = self.myTable.dequeueReusableCell(withIdentifier: "HeaderToDayTableViewCell") as! HeaderToDayTableViewCell
            HeaderToday.buttonPressed = {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let seeAllTodayVC = sb.instantiateViewController(identifier: "SeeAllTodayViewController") as! SeeAllTodayViewController
                seeAllTodayVC.mealObjs = self.mealObjs
                seeAllTodayVC.alltodayEvent = self.alltodayEvent
                self.navigationController?.pushViewController(seeAllTodayVC, animated: true)
            }
            return HeaderToday
        case 2:
            let headerRecommended = self.myTable.dequeueReusableCell(withIdentifier: "HeaderRecommendedTableViewCell") as! HeaderRecommendedTableViewCell
            headerRecommended.buttonPressed = {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let seeAllRecommendedVC = sb.instantiateViewController(identifier: "SeeAllRecommendedViewController") as! SeeAllRecommendedViewController
                seeAllRecommendedVC.seeAllRecomemendedEvent = self.sortedArray
                seeAllRecommendedVC.mealObjs = self.mealObjs
                self.navigationController?.pushViewController(seeAllRecommendedVC, animated: true)
            }
            return headerRecommended
        default:
            break
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section) == 2 {
            
            if alltodayEvent?.count != 0 {
                let selectedItem = RecommendedEvent![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            }
            if alltodayEvent?.count == 0 {
                let selectedItem = sortedArray![indexPath.item]
                let detaiVC = self.navigationController?.mainStoryBoard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                detaiVC.dishObj = selectedItem
                //MARK: TESt
                let updatedDate =  Date()
                try! realm.write {
                    selectedItem.upDataDate = updatedDate
                    detaiVC.dishObj?.upDataDate = selectedItem.upDataDate
                }
                self.navigationController?.pushViewController(detaiVC, animated: true)
            }
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let addDishVC = sb.instantiateViewController(identifier: "AddNewDishViewController") as! AddNewDishViewController
        self.navigationController?.pushViewController(addDishVC, animated: true)
    }
}


