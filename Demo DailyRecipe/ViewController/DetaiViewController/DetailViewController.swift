//
//  DetailViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 21/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //MARK: Call Back reloadData CollectionView
    var callBackCell: ((_ data: DishObj?) -> Void)?
    
    @IBOutlet weak var myTable: UITableView!{
        didSet{
            self.myTable.delegate = self
            self.myTable.dataSource = self
        }
    }
    var dishObj: DishObj?
    var alltodayEvent: [DishObj]?
    var RecommendedEvent: [DishObj]?
    var sortedArray: [DishObj]?
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
        
        mealObjs = realm.objects(MealObj.self).toArray(ofType: MealObj.self)
        
        myTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            if indexPath.row == 0 {
                let cell1 = self.myTable.dequeueReusableCell(withIdentifier: "BreakfastTableViewCell", for: indexPath) as! BreakfastTableViewCell
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == dishObj!.mealID}
                    cell1.mealLabel.text = mealObj?.name
                }
                
                let urlString = dishObj!.urlDish
                cell1.foodImage.kf.setImage(with: URL(string: urlString!))
                cell1.nameLabel.text = dishObj!.name
                cell1.caloLabel.text = String(dishObj!.calories) + " Calories"
                cell1.minLabel.text = String(dishObj!.prepareTime) + " mins"
                cell1.servingLabel.text = String(dishObj!.serving) + " Serving"
                if dishObj!.isLiked == false {
                    cell1.isLikedButton.setImage(UIImage(named: "ic_like_today1"), for: UIControl.State.normal)
                } else {
                    cell1.isLikedButton.setImage(UIImage(named: "ic_like_today2"), for: UIControl.State.normal)
                }
                //MARK: onIsLike
                cell1.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if self.dishObj!.isLiked == false {
                        cell1.isLikedButton.setImage(UIImage(named: "ic_like_today2"), for: UIControl.State.normal)
                        try! realm.write {
                            self.dishObj!.isLiked = true
                        }
                    } else {
                        cell1.isLikedButton.setImage(UIImage(named: "ic_like_today1"), for: UIControl.State.normal)
                        try! realm.write {
                            self.dishObj!.isLiked = false
                        }
                    }
                }
                if dishObj!.rating == 1 {
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj!.rating == 2 {
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj!.rating == 3 {
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj!.rating == 4 {
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if dishObj!.rating == 5 {
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                
                //MARK: onRating
                cell1.ratingButton1CallBack = {
                    let realm = try! Realm()
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    try! realm.write {
                        self.dishObj!.rating = 1
                    }
                }
                cell1.ratingButton2CallBack = {
                    let realm = try! Realm()
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    try! realm.write {
                        self.dishObj!.rating = 2
                    }
                }
                cell1.ratingButton3CallBack = {
                    let realm = try! Realm()
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    try! realm.write {
                        self.dishObj!.rating = 3
                    }
                }
                cell1.ratingButton4CallBack = {
                    let realm = try! Realm()
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    try! realm.write {
                        self.dishObj!.rating = 4
                    }
                }
                cell1.ratingButton5CallBack = {
                    let realm = try! Realm()
                    cell1.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell1.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    try! realm.write {
                        self.dishObj!.rating = 5
                    }
                }
                return cell1
            }
            
        case 1:
            if indexPath.row == 0 {
            let cell2 = self.myTable.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
                cell2.onDidSelectIcon = {(indexPath) in
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let DirectionsVC = sb.instantiateViewController(identifier: "DirectionsDetailViewController") as! DirectionsDetailViewController
                    DirectionsVC.recomemendedObj = self.dishObj
//                    DirectionsVC.recomemended = self.recomemended
                    self.present(DirectionsVC, animated: true, completion: nil)
                }
            return cell2
            }
        case 2:
            let cell3 = self.myTable.dequeueReusableCell(withIdentifier: "RecomdetailTableViewCell") as! RecomdetailTableViewCell
            
            if alltodayEvent?.count != 0 {
                
                let recommendedEvent = RecommendedEvent![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == recommendedEvent.mealID}
                    cell3.mealLabel.text = mealObj?.name
                }
                
                let urlString = recommendedEvent.urlDish
                cell3.foodImage.kf.setImage(with: URL(string: urlString!))
                cell3.nameLabel.text = recommendedEvent.name
                cell3.caloLabel.text = String(recommendedEvent.calories) + " Calories"
                cell3.minLabel.text = String(recommendedEvent.prepareTime) + " mins"
                cell3.servingLabel.text = String(recommendedEvent.serving) + " Serving"
                
                if recommendedEvent.isLiked == false {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell3.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if recommendedEvent.isLiked == false {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recommendedEvent.isLiked = true
                        }
                    } else {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            recommendedEvent.isLiked = false
                        }
                    }
                }
                
                if recommendedEvent.rating == 1 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedEvent.rating == 2 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedEvent.rating == 3 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedEvent.rating == 4 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if recommendedEvent.rating == 5 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                return cell3
            }
            if alltodayEvent?.count == 0 {
                let sortedArrayEvent = sortedArray![indexPath.row]
                
                if let mealArr = self.mealObjs {
                    let mealObj = mealArr.first { $0.id == sortedArrayEvent.mealID}
                    cell3.mealLabel.text = mealObj?.name
                }
                
                let urlString = sortedArrayEvent.urlDish
                cell3.foodImage.kf.setImage(with: URL(string: urlString!))
                cell3.nameLabel.text = sortedArrayEvent.name
                cell3.caloLabel.text = String(sortedArrayEvent.calories) + " Calories"
                cell3.minLabel.text = String(sortedArrayEvent.prepareTime) + " mins"
                cell3.servingLabel.text = String(sortedArrayEvent.serving) + " Serving"
                
                if sortedArrayEvent.isLiked == false {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                } else {
                    cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                }
                cell3.buttonIsLikedCallBack = {
                    let realm = try! Realm()
                    if sortedArrayEvent.isLiked == false {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_heart.png"), for: UIControl.State.normal)
                        try! realm.write {
                            sortedArrayEvent.isLiked = true
                        }
                    } else {
                        cell3.isLikedButton.setImage(UIImage(named: "ic_dw_favorite.png"), for: UIControl.State.normal)
                        try! realm.write {
                            sortedArrayEvent.isLiked = false
                        }
                    }
                }
                
                if sortedArrayEvent.rating == 1 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sortedArrayEvent.rating == 2 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sortedArrayEvent.rating == 3 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sortedArrayEvent.rating == 4 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                }
                if sortedArrayEvent.rating == 5 {
                    cell3.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                    cell3.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                }
                return cell3
            }
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0:
            return 275
        case 1:
            return 98
        case 2:
            return 109
        default:
            break
        }
        return 0
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:
            let headerRecommended = self.myTable.dequeueReusableCell(withIdentifier: "HeaderRCMdetailTableViewCell") as! HeaderRCMdetailTableViewCell
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
        case 1:
            return 0
        default:
            return 60
        }
    }

    
    
    
    @IBAction func onBack(_ sender: Any) {
        self.callBackCell?(dishObj)
        self.navigationController?.popViewController(animated: true)
    }
}
