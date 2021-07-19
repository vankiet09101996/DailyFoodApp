//
//  DirectionsDetailViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 22/06/2021.
//

import UIKit
import RealmSwift
import Kingfisher

class DirectionsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recomemendedObj: DishObj?
    @IBOutlet weak var myTable: UITableView! {
        didSet{
            self.myTable.delegate = self
            self.myTable.dataSource = self
        }
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
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return 139
            }
        case 1:
            if (indexPath.row == 0) {
                return 96
            }
        case 2:
            return 498
        default:
            break
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = self.myTable.dequeueReusableCell(withIdentifier: "FrenchToastTableViewCell", for: indexPath) as! FrenchToastTableViewCell
            cell.nameLabel.text = recomemendedObj?.name
            cell.caloLabel.text = String(recomemendedObj!.calories) + " Calories"
            cell.minLabel.text = String(recomemendedObj!.prepareTime) + " mins"
            cell.servingLabel.text = String(recomemendedObj!.serving) + " Serving"
            if recomemendedObj!.isLiked == false {
                cell.isLikeButton.setImage(UIImage(named: "ic_like_today1"), for: UIControl.State.normal)
            } else {
                cell.isLikeButton.setImage(UIImage(named: "ic_like_today2"), for: UIControl.State.normal)
            }
            cell.buttonIsLikedCallBack = {
                let realm = try! Realm()
                if self.recomemendedObj!.isLiked == false {
                    cell.isLikeButton.setImage(UIImage(named: "ic_like_today2"), for: UIControl.State.normal)
                    try! realm.write {
                        self.recomemendedObj!.isLiked = true
                    }
                } else {
                    cell.isLikeButton.setImage(UIImage(named: "ic_like_today1"), for: UIControl.State.normal)
                    try! realm.write {
                        self.recomemendedObj!.isLiked = false
                    }
                }
            }
            return cell
        case 1:
            let cell = self.myTable.dequeueReusableCell(withIdentifier: "DirectionsIngredientsTableViewCell", for: indexPath)
            return cell
        case 2:
            let cell = self.myTable.dequeueReusableCell(withIdentifier: "DetailTextTableViewCell", for: indexPath) as! DetailTextTableViewCell
            cell.myTextView.text = recomemendedObj?.descriptions
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:
            let HeaderDirections = self.myTable.dequeueReusableCell(withIdentifier: "HeaderDirectionsTableViewCell")
            return HeaderDirections
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
            return 55
        }
    }
}
