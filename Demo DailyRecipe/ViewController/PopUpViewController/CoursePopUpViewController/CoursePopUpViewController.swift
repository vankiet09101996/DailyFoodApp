//
//  CoursePopUpViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 24/06/2021.
//

import UIKit
import RealmSwift
class CoursePopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: CallBack?
    var onCourseSelectd: ((_ course:CourseObj?) -> Void)?
    //MARK: Outlet button

    
    //MARK: Outlet View
    @IBOutlet weak var myTable: UITableView! {
        didSet {
            myTable.delegate = self
            myTable.dataSource = self
            myTable.rowHeight = 40
        }
    }
    
    //MARK: Variables
    var courseObjs = [CourseObj]()
    var courseSelected: CourseObj?
    var selectedIndex: IndexPath!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let Soup = CourseObj()
        Soup.id = 1
        Soup.name = "Soup"
        courseObjs.append(Soup)
        
        let Appetizer = CourseObj()
        Appetizer.id = 2
        Appetizer.name = "Appetizer"
        courseObjs.append(Appetizer)
        
        let Starter = CourseObj()
        Starter.id = 3
        Starter.name = "Starter"
        courseObjs.append(Starter)
        
        let MainDish = CourseObj()
        MainDish.id = 4
        MainDish.name = "Main Dish"
        courseObjs.append(MainDish)
        
        let Side = CourseObj()
        Side.id = 5
        Side.name = "Side"
        courseObjs.append(Side)
        
        let Dessert = CourseObj()
        Dessert.id = 6
        Dessert.name = "Dessert"
        courseObjs.append(Dessert)
        
        let Drinks = CourseObj()
        Drinks.id = 7
        Drinks.name = "Drinks"
        courseObjs.append(Drinks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseObjs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCell(withIdentifier: "CoursePopUptableViewCell", for: indexPath) as! CoursePopUptableViewCell
        cell.nameLabel.text = courseObjs[indexPath.row].name
        
        cell.checkMarkImage.isHidden = true

        if let courseSelected = courseSelected {
            let isExistCourse = courseObjs[indexPath.row].id == courseSelected.id ? true : false
            if( courseObjs[indexPath.row].id == courseSelected.id){
                            selectedIndex = indexPath
                        }
            cell.checkMarkImage.isHidden = !isExistCourse
        }

        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let HeaderCourse = self.myTable.dequeueReusableCell(withIdentifier: "HearCoursePopUpTableViewCell") as! HearCoursePopUpTableViewCell
        return HeaderCourse
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedcell = myTable.cellForRow(at: indexPath) as! CoursePopUptableViewCell
        if selectedIndex != nil {
            let previousCell = myTable.cellForRow(at: selectedIndex!) as! CoursePopUptableViewCell
            previousCell.checkMarkImage.isHidden = true
        }
        selectedcell.checkMarkImage.isHidden = false
        
        selectedIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        onCourseSelectd!(courseObjs[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
