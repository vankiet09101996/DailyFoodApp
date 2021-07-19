//
//  MealPopUpViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 24/06/2021.
//

import UIKit
import RealmSwift
class MealPopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: outlet
    @IBOutlet weak var myTable: UITableView! {
        didSet {
            myTable.delegate = self
            myTable.dataSource = self
            myTable.rowHeight = 40
        }
    }
    
    //MARK: outlet View
    @IBOutlet weak var viewBottom: UIView!
    //MARK: CallBack
    var onMealSelectd: ((_ meal:MealObj?) -> Void)?
    //MARK: Variables
    var mealObjs = [MealObj]() //"Breakfast", "Brunch", "Lunch", "Dinner"
    //    var course = ["Soup", "Appetizer", "Starter", "Main Dish", "Side", "Dessert", "Drinks"]
    var mealSelected: MealObj?
    var selectedIndex: IndexPath!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let Breakfast = MealObj()
        Breakfast.id = 1
        Breakfast.name = "Breakfast"
        mealObjs.append(Breakfast)
        
        let Brunch = MealObj()
        Brunch.id = 2
        Brunch.name = "Brunch"
        mealObjs.append(Brunch)
        
        let Lunch = MealObj()
        Lunch.id = 3
        Lunch.name = "Lunch"
        mealObjs.append(Lunch)
        
        let Dinner = MealObj()
        Dinner.id = 4
        Dinner.name = "Dinner"
        mealObjs.append(Dinner)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealObjs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCell(withIdentifier: "MealPopUptableViewCell", for: indexPath) as! MealPopUptableViewCell
        cell.mealLabel.text = mealObjs[indexPath.row].name
        //MARK: CHECKMARK giữ nguyên vị trí CheckMark khi kích chọn lại
        cell.mealImage.isHidden = true
        
        if let mealSelected = mealSelected {
            let isExistMeal = mealObjs[indexPath.row].id == mealSelected.id ? true : false
            if( mealObjs[indexPath.row].id == mealSelected.id){
                selectedIndex = indexPath
            }
            cell.mealImage.isHidden = !isExistMeal
        }
        
        //        if let mealSelected = mealSelected {
        //            let isExistMeal = mealObjs.firstIndex(of: mealSelected)
        //            if isExistMeal != 1 {
        //                cell.mealImage.isHidden = false
        //            }
        //        }
        
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let HeaderMeal = self.myTable.dequeueReusableCell(withIdentifier: "HeaderMealPopUpTableViewCell") as! HeaderMealPopUpTableViewCell
        return HeaderMeal
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedcell = myTable.cellForRow(at: indexPath) as! MealPopUptableViewCell
        if selectedIndex != nil {
            let previousCell = myTable.cellForRow(at: selectedIndex!) as! MealPopUptableViewCell
            previousCell.mealImage.isHidden = true
        }
        selectedcell.mealImage.isHidden = false
        
        
        
        selectedIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        onMealSelectd!(mealObjs[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
