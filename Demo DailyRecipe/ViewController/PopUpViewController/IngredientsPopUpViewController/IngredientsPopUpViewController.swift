//
//  IngredientsPopUpViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 24/06/2021.
//

import UIKit
import RealmSwift
class IngredientsPopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: OutLet
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var myTable: UITableView! {
        didSet {
            myTable.delegate = self
            myTable.dataSource = self
            myTable.rowHeight = 40
        }
    }
    //MARK: CallBack
    var onIngredientsSelected: ((_ ingredients:[IngredientsObj]?) -> Void)?
    
    //MARK: Variables
    var inngredientsObj = [IngredientsObj]()
    var inngredientsSelected : [IngredientsObj]?
    var selectedIndex: IndexPath!
    var resources: [String] = ["Flour", "Butter", "Egg", "Water", "Strawberry", "Grapes", "Apple"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let Flour = IngredientsObj()
//        Flour.id = 1
//        Flour.name = "Breakfast"
//        inngredientsObj.append(Flour)
//
//        let Butter = IngredientsObj()
//        Butter.id = 2
//        Butter.name = "Butter"
//        inngredientsObj.append(Butter)
//
//        let Egg = IngredientsObj()
//        Egg.id = 3
//        Egg.name = "Egg"
//        inngredientsObj.append(Egg)
//
//        let Water = IngredientsObj()
//        Water.id = 4
//        Water.name = "Water"
//        inngredientsObj.append(Water)
//
//        let Strawberry = IngredientsObj()
//        Strawberry.id = 5
//        Strawberry.name = "Strawberry"
//        inngredientsObj.append(Strawberry)
//
//        let Grapes = IngredientsObj()
//        Grapes.id = 6
//        Grapes.name = "Grapes"
//        inngredientsObj.append(Grapes)
//
//        let Apple = IngredientsObj()
//        Apple.id = 7
//        Apple.name = "Apple"
//        inngredientsObj.append(Apple)
//
        
        
    }
    var indexNumber:NSInteger = -1
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTable.dequeueReusableCell(withIdentifier: "FooterIngredientsTableViewCell", for: indexPath) as! FooterIngredientsTableViewCell
        cell.nameLabel.text = resources[indexPath.row]
        
        cell.checkMarkImage.isHidden = true

        if let inngredientsSelected = inngredientsSelected {
            if indexPath.row == 0 {
                if (inngredientsSelected.firstIndex{ $0.id == 1} != nil) {
                    cell.checkMarkImage.isHidden = false
                    let Flour = IngredientsObj()
                    Flour.id = 1
                    Flour.name = "Flour"
                    inngredientsObj.append(Flour)
                    //                    onIngredientsSelected?(inngredientsObj)
                    print(inngredientsObj)
                }
            }
            if indexPath.row == 1 {
                if (inngredientsSelected.firstIndex{ $0.id == 2} != nil) {
                    cell.checkMarkImage.isHidden = false
                    let Butter = IngredientsObj()
                    Butter.id = 2
                    Butter.name = "Butter"
                    inngredientsObj.append(Butter)
                    //                    onIngredientsSelected?(inngredientsObj)
                    print(inngredientsObj)
                }
            }
            if indexPath.row == 2 {
                if (inngredientsSelected.firstIndex{ $0.id == 3} != nil) {
                    cell.checkMarkImage.isHidden = false
                    let Egg = IngredientsObj()
                    Egg.id = 3
                    Egg.name = "Egg"
                    inngredientsObj.append(Egg)
                    //                    onIngredientsSelected?(inngredientsObj)
                    print(inngredientsObj)
                }
            }
            if indexPath.row == 3 {
                if (inngredientsSelected.firstIndex{ $0.id == 4} != nil) {
                    cell.checkMarkImage.isHidden = false
                    let Water = IngredientsObj()
                    Water.id = 4
                    Water.name = "Water"
                    inngredientsObj.append(Water)
                    //                    onIngredientsSelected?(inngredientsObj)
                    print(inngredientsObj)
                }
            }
            if indexPath.row == 4 {
                if (inngredientsSelected.firstIndex{ $0.id == 5} != nil) {
                    cell.checkMarkImage.isHidden = false
                    let Strawberry = IngredientsObj()
                    Strawberry.id = 5
                    Strawberry.name = "Strawberry"
                    inngredientsObj.append(Strawberry)
                    //                    onIngredientsSelected?(inngredientsObj)
                    print(inngredientsObj)
                }
            }
            if indexPath.row == 5 {
                if (inngredientsSelected.firstIndex{ $0.id == 6} != nil) {
                    cell.checkMarkImage.isHidden = false
                    let Grapes = IngredientsObj()
                    Grapes.id = 6
                    Grapes.name = "Grapes"
                    inngredientsObj.append(Grapes)
                    //                    onIngredientsSelected?(inngredientsObj)
                    print(inngredientsObj)
                }
            }
            if indexPath.row == 6 {
                if (inngredientsSelected.firstIndex{ $0.id == 7} != nil) {
                    cell.checkMarkImage.isHidden = false
                    let Apple = IngredientsObj()
                    Apple.id = 7
                    Apple.name = "Apple"
                    inngredientsObj.append(Apple)
                    //                    onIngredientsSelected?(inngredientsObj)
                    print(inngredientsObj)
                }
            }
        }


//        if let inngredientsSelected = inngredientsSelected {
//            let isExistInngredients = inngredientsObj.count == inngredientsSelected.count ? true : false
//            if inngredientsSelected[indexPath.row].id != 0 {
//                cell.checkMarkImage.isHidden = isExistInngredients
//            }
//        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let HeaderIngredients = self.myTable.dequeueReusableCell(withIdentifier: "HeaderIngredientsTableViewCell") as! HeaderIngredientsTableViewCell
        return HeaderIngredients
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = myTable.cellForRow(at: indexPath) as! FooterIngredientsTableViewCell
        
        if indexPath.row == 0 {
            if cell.checkMarkImage.isHidden == false
            {
                cell.checkMarkImage.isHidden = true
                let index1 = inngredientsObj.firstIndex{ $0.id == 1}
                if let index1 = index1 {
                    inngredientsObj.remove(at: index1)

                }
                selectedIndex = indexPath
                print(inngredientsObj)
            }
            else
            {
                cell.checkMarkImage.isHidden = false
                let Flour = IngredientsObj()
                Flour.id = 1
                Flour.name = "Flour"
                inngredientsObj.append(Flour)
                //                    onIngredientsSelected?(inngredientsObj)
                print(inngredientsObj)
            }
        }
        if indexPath.row == 1 {
            if cell.checkMarkImage.isHidden == false
            {
                cell.checkMarkImage.isHidden = true
                let index1 = inngredientsObj.firstIndex{ $0.id == 2}
                if let index1 = index1 {
                    inngredientsObj.remove(at: index1)

                }
                selectedIndex = indexPath
                print(inngredientsObj)
            }
            else
            {
                cell.checkMarkImage.isHidden = false
                let Butter = IngredientsObj()
                Butter.id = 2
                Butter.name = "Butter"
                inngredientsObj.append(Butter)
                //                    onIngredientsSelected?(inngredientsObj)
                print(inngredientsObj)
            }
        }
        if indexPath.row == 2 {
            if cell.checkMarkImage.isHidden == false
            {
                cell.checkMarkImage.isHidden = true
                let index1 = inngredientsObj.firstIndex{ $0.id == 3}
                if let index1 = index1 {
                    inngredientsObj.remove(at: index1)

                }
                selectedIndex = indexPath
                print(inngredientsObj)
            }
            else
            {
                cell.checkMarkImage.isHidden = false
                let Egg = IngredientsObj()
                Egg.id = 3
                Egg.name = "Egg"
                inngredientsObj.append(Egg)
                //                    onIngredientsSelected?(inngredientsObj)
                print(inngredientsObj)
            }
        }
        if indexPath.row == 3 {
            if cell.checkMarkImage.isHidden == false
            {
                cell.checkMarkImage.isHidden = true
                let index1 = inngredientsObj.firstIndex{ $0.id == 4}
                if let index1 = index1 {
                    inngredientsObj.remove(at: index1)

                }
                selectedIndex = indexPath
                print(inngredientsObj)
            }
            else
            {
                cell.checkMarkImage.isHidden = false
                let Water = IngredientsObj()
                Water.id = 4
                Water.name = "Water"
                inngredientsObj.append(Water)
                //                    onIngredientsSelected?(inngredientsObj)
                print(inngredientsObj)
            }
        }
        if indexPath.row == 4 {
            if cell.checkMarkImage.isHidden == false
            {
                cell.checkMarkImage.isHidden = true
                let index1 = inngredientsObj.firstIndex{ $0.id == 5}
                if let index1 = index1 {
                    inngredientsObj.remove(at: index1)

                }
                selectedIndex = indexPath
                print(inngredientsObj)
            }
            else
            {
                cell.checkMarkImage.isHidden = false
                let Strawberry = IngredientsObj()
                Strawberry.id = 5
                Strawberry.name = "Strawberry"
                inngredientsObj.append(Strawberry)
                //                    onIngredientsSelected?(inngredientsObj)
                print(inngredientsObj)
            }
        }

        if indexPath.row == 5 {
            if cell.checkMarkImage.isHidden == false
            {
                cell.checkMarkImage.isHidden = true
                let index1 = inngredientsObj.firstIndex{ $0.id == 6}
                if let index1 = index1 {
                    inngredientsObj.remove(at: index1)

                }
                selectedIndex = indexPath
                print(inngredientsObj)
            }
            else
            {
                cell.checkMarkImage.isHidden = false
                let Grapes = IngredientsObj()
                Grapes.id = 6
                Grapes.name = "Grapes"
                inngredientsObj.append(Grapes)
                //                    onIngredientsSelected?(inngredientsObj)
                print(inngredientsObj)
            }
        }
        if indexPath.row == 6 {
            if cell.checkMarkImage.isHidden == false
            {
                cell.checkMarkImage.isHidden = true
                let index1 = inngredientsObj.firstIndex{ $0.id == 7}
                if let index1 = index1 {
                    inngredientsObj.remove(at: index1)

                }
                selectedIndex = indexPath
                print(inngredientsObj)
            }
            else
            {
                cell.checkMarkImage.isHidden = false
                let Apple = IngredientsObj()
                Apple.id = 7
                Apple.name = "Apple"
                inngredientsObj.append(Apple)
                //                    onIngredientsSelected?(inngredientsObj)
                print(inngredientsObj)
            }
        }
    }
            
            
            //            if indexPath.row == 0 {
            //                if cell.accessoryType == .checkmark
            //                {
            //                    cell.accessoryType = .none
            //                    let index1 = inngredientsObj.firstIndex{ $0.id == 1}
            //                    if let index1 = index1 {
            //                        inngredientsObj.remove(at: index1)
            //
            //                    }
            //                    print(inngredientsObj)
            //                }
            //                else
            //                {
            //                    cell.accessoryType = .checkmark
            //                    let Flour = IngredientsObj()
            //                    Flour.id = 1
            //                    Flour.name = "Flour"
            //                    inngredientsObj.append(Flour)
            ////                    onIngredientsSelected?(inngredientsObj)
            //                    print(inngredientsObj)
            //                }
            //            }
            //            if indexPath.row == 1 {
            //                if cell.accessoryType == .checkmark
            //                {
            //                    cell.accessoryType = .none
            //                    let index2 = inngredientsObj.firstIndex{ $0.id == 2}
            //                    if let index2 = index2 {
            //                        inngredientsObj.remove(at: index2)
            //
            //                    }
            //                    print(inngredientsObj)
            //                }
            //                else
            //                {
            //                    cell.accessoryType = .checkmark
            //                    let Butter = IngredientsObj()
            //                    Butter.id = 2
            //                    Butter.name = "Butter"
            //                    inngredientsObj.append(Butter)
            ////                    onIngredientsSelected?(inngredientsObj)
            //                    print(inngredientsObj)
            //                }
            //            }
            //            if indexPath.row == 2 {
            //                if cell.accessoryType == .checkmark
            //                {
            //                    cell.accessoryType = .none
            //                    let index = inngredientsObj.firstIndex{ $0.name == "Egg"}
            //                    if let index = index {
            //                        inngredientsObj.remove(at: index)
            //
            //                    }
            //                    print(inngredientsObj)
            //                }
            //                else
            //                {
            //                    cell.accessoryType = .checkmark
            //                    let Egg = IngredientsObj()
            //                    Egg.id = 3
            //                    Egg.name = "Egg"
            //                    inngredientsObj.append(Egg)
            ////                    onIngredientsSelected?(inngredientsObj)
            //                    print(inngredientsObj)
            //                }
            //            }
            //            if indexPath.row == 3 {
            //                if cell.accessoryType == .checkmark
            //                {
            //                    cell.accessoryType = .none
            //                    let index = inngredientsObj.firstIndex{ $0.name == "Water"}
            //                    if let index = index {
            //                        inngredientsObj.remove(at: index)
            //
            //                    }
            //                    print(inngredientsObj)
            //                }
            //                else
            //                {
            //                    cell.accessoryType = .checkmark
            //                    let Water = IngredientsObj()
            //                    Water.id = 4
            //                    Water.name = "Water"
            //                    inngredientsObj.append(Water)
            ////                    onIngredientsSelected?(inngredientsObj)
            //                    print(inngredientsObj)
            //                }
            //            }
            //            if indexPath.row == 4 {
            //                if cell.accessoryType == .checkmark
            //                {
            //                    cell.accessoryType = .none
            //                    let index = inngredientsObj.firstIndex{ $0.name == "Strawberry"}
            //                    if let index = index {
            //                        inngredientsObj.remove(at: index)
            //
            //                    }
            //                    print(inngredientsObj)
            //                }
            //                else
            //                {
            //                    cell.accessoryType = .checkmark
            //                    let Strawberry = IngredientsObj()
            //                    Strawberry.id = 5
            //                    Strawberry.name = "Strawberry"
            //                    inngredientsObj.append(Strawberry)
            ////                    onIngredientsSelected?(inngredientsObj)
            //                    print(inngredientsObj)
            //                }
            //            }
            //            if indexPath.row == 5 {
            //                if cell.accessoryType == .checkmark
            //                {
            //                    cell.accessoryType = .none
            //                    let index = inngredientsObj.firstIndex{ $0.name == "Grapes"}
            //                    if let index = index {
            //                        inngredientsObj.remove(at: index)
            //
            //                    }
            //                    print(inngredientsObj)
            //                }
            //                else
            //                {
            //                    cell.accessoryType = .checkmark
            //                    let Grapes = IngredientsObj()
            //                    Grapes.id = 6
            //                    Grapes.name = "Grapes"
            //                    inngredientsObj.append(Grapes)
            ////                    onIngredientsSelected?(inngredientsObj)
            //                    print(inngredientsObj)
            //                }
            //            }
            //            if indexPath.row == 6 {
            //                if cell.accessoryType == .checkmark
            //                {
            //                    cell.accessoryType = .none
            //                    let index = inngredientsObj.firstIndex{ $0.name == "Apple"}
            //                    if let index = index {
            //                        inngredientsObj.remove(at: index)
            //
            //                    }
            //                    print(inngredientsObj)
            //                }
            //                else
            //                {
            //                    cell.accessoryType = .checkmark
            //                    let Apple = IngredientsObj()
            //                    Apple.id = 7
            //                    Apple.name = "Apple"
            //                    inngredientsObj.append(Apple)
            ////                    onIngredientsSelected?(inngredientsObj)
            //                    print(inngredientsObj)
            //                }
            //            }

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onOk(_ sender: Any) {
        self.onIngredientsSelected?(self.inngredientsObj)
        print(self.inngredientsObj)
        self.dismiss(animated: true, completion: nil)
    }
}
