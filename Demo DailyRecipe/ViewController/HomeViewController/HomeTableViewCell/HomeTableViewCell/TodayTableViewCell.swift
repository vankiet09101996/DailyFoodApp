//
//  CollecTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 18/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher

class TodayTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: CallBack
    var onDidSelectItem: ((IndexPath) -> ())?
    @IBOutlet weak var myCollectionView: UICollectionView! {
        didSet {
            self.myCollectionView.delegate = self
            self.myCollectionView.dataSource = self
            setLayout()
        }
    }
    
    var realm: Realm!
    var dishs: [DishObj]?
    var dishsObj: DishObj?
    var mealObjs: [MealObj]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let realm = try! Realm()
        dishs = realm.objects(DishObj.self).toArray(ofType: DishObj.self)
        mealObjs = realm.objects(MealObj.self).toArray(ofType: MealObj.self)
        myCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
    func setLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: self.myCollectionView.frame.width/2 - 10 , height: self.myCollectionView.frame.height + 25)
        self.myCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //MARK: lấy danh sách theo ngày hiện tại
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        resultDay = date.convertToString()
        let todayEvent = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)'")
        if (todayEvent.count) > 0 {
            return todayEvent.count
        }
//        else if (todayEvent.count) < 0 {
//            let sortedArray = realm.objects(DishObj.self).sorted(by: {$0.createDate.compare($1.createDate) == .orderedAscending})
//            let first10sortedArray = sortedArray.prefix(10)
//            return first10sortedArray.count
//        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        //MARK: test
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        let updatedDate =  Date()
        resultDay = updatedDate.convertToString()
        let todayEvent = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)'")
        let dish = todayEvent[indexPath.row]
        
        
//      get URL image
        let urlString = dish.urlDish
        
        if (todayEvent.count) > 0 {
            
            if let mealArr = self.mealObjs {
                let mealObj = mealArr.first { $0.id == dish.mealID}
                cell.mealLabel.text = mealObj?.name
            }
            
            cell.foodImage.kf.setImage(with: URL(string: urlString!))
            cell.nameLabel.text = dish.name
            cell.caloLabel.text = String(dish.calories) + " Calories"
            cell.minLabel.text = String(dish.prepareTime) + " mins"
            cell.servingLabel.text = String(dish.serving) + " Serving"
            if dish.isLiked == false{
                cell.isLikedButton.setImage(UIImage(named: "ic_like_today1"), for: UIControl.State.normal)
            } else {
                cell.isLikedButton.setImage(UIImage(named: "ic_like_today2"), for: UIControl.State.normal)
            }
            cell.buttonIsLikedCallBack = {
                if dish.isLiked == false {
                    cell.isLikedButton.setImage(UIImage(named: "ic_like_today2"), for: UIControl.State.normal)
                    try! realm.write {
                        dish.isLiked = true
                    }
                } else {
                    cell.isLikedButton.setImage(UIImage(named: "ic_like_today1"), for: UIControl.State.normal)
                    try! realm.write {
                        dish.isLiked = false
                    }
                }
            }
            if dish.rating == 1 {
                cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton2.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
            }
            if dish.rating == 2 {
                cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton3.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
            }
            if dish.rating == 3 {
                cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton4.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
                cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
            }
            if dish.rating == 4 {
                cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton5.setImage(UIImage(named: "btn_rating0"), for: UIControl.State.normal)
            }
            if dish.rating == 5 {
                cell.ratingButton1.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton2.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton3.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton4.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
                cell.ratingButton5.setImage(UIImage(named: "btn_rating"), for: UIControl.State.normal)
            }
            return cell
        }
//        else if (todayEvent.count) < 0 {
//            let sortedArray = realm.objects(DishObj.self).sorted(by: {$0.createDate.compare($1.createDate) == .orderedAscending})
//            let sortedDish = sortedArray[indexPath.row]
//            let urlString = sortedDish.urlDish
//            let url = URL(string: urlString!)
//            let data = try! Data(contentsOf: (url)!)
//
//            cell.foodImage.image = UIImage(data: data)
//            cell.mealLabel.text = String(sortedDish.mealID)
//            cell.nameLabel.text = sortedDish.name
//            cell.starLabel.text = "✩✩✩✩✩"
//            cell.caloLabel.text = String(sortedDish.calories)
//            cell.minLabel.text = String(sortedDish.prepareTime!)
//            cell.servingLabel.text = String(sortedDish.serving)
//
//            return cell
//        }
        return UICollectionViewCell()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.myCollectionView.reloadData()
        self.myCollectionView.reloadItems(at: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onDidSelectItem?(indexPath)
    }
    


        
    

}
