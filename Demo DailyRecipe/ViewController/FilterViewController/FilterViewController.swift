//
//  FilterViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 23/06/2021.
//


import UIKit
import RealmSwift
class FilterViewController: UIViewController {
    
    @IBOutlet weak var servingSlider: UISlider!
    @IBOutlet weak var minSlider: UISlider!
    @IBOutlet weak var caloSlider: UISlider!
    
    @IBOutlet var ServingLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var caloLabel: UILabel!
    
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var bunchButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    
    @IBOutlet weak var sourpButton: UIButton!
    @IBOutlet weak var appertiezButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var mainDizButton: UIButton!
    @IBOutlet weak var sideButton: UIButton!
    @IBOutlet weak var dessertButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    
    @IBOutlet weak var applyButton: UIButton!
    //MARK: CallBack
    var onDishFilter: ((_ filterObj:FilterObj?) -> Void)?
    //MARK: Variables
    //    var dishFilter = [DishObj]()
    //    var filterObj:DishObj?
    var filterObj = FilterObj()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lunchButton.layer.cornerRadius = 8
        bunchButton.layer.cornerRadius = 8
        breakfastButton.layer.cornerRadius = 8
        dinnerButton.layer.cornerRadius = 8
        sourpButton.layer.cornerRadius = 8
        appertiezButton.layer.cornerRadius = 8
        starButton.layer.cornerRadius = 8
        mainDizButton.layer.cornerRadius = 8
        sideButton.layer.cornerRadius = 8
        dessertButton.layer.cornerRadius = 8
        drinkButton.layer.cornerRadius = 8
        
        applyButton.layer.cornerRadius = 15
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setData()
    }
    
    func setData() {
        //MARK: setData mealID
        if filterObj.mealID == 1 {
            breakfastButton.backgroundColor = UIColor(named: "bg_button-color")
            breakfastButton.layer.borderColor = UIColor.orange.cgColor
            breakfastButton.layer.borderWidth = 1
        }
        if filterObj.mealID == 2 {
            bunchButton.backgroundColor = UIColor(named: "bg_button-color")
            bunchButton.layer.borderColor = UIColor.orange.cgColor
            bunchButton.layer.borderWidth = 1
        }
        if filterObj.mealID == 3 {
            lunchButton.backgroundColor = UIColor(named: "bg_button-color")
            lunchButton.layer.borderColor = UIColor.orange.cgColor
            lunchButton.layer.borderWidth = 1
        }
        if filterObj.mealID == 4 {
            dinnerButton.backgroundColor = UIColor(named: "bg_button-color")
            dinnerButton.layer.borderColor = UIColor.orange.cgColor
            dinnerButton.layer.borderWidth = 1
        }
        //MARK: setData CourseID
        if filterObj.courseID == 1 {
            sourpButton.backgroundColor = UIColor(named: "bg_button-color")
            sourpButton.layer.borderColor = UIColor.orange.cgColor
            sourpButton.layer.borderWidth = 1
        }
        if filterObj.courseID == 2 {
            appertiezButton.backgroundColor = UIColor(named: "bg_button-color")
            appertiezButton.layer.borderColor = UIColor.orange.cgColor
            appertiezButton.layer.borderWidth = 1
        }
        if filterObj.courseID == 3 {
            starButton.backgroundColor = UIColor(named: "bg_button-color")
            starButton.layer.borderColor = UIColor.orange.cgColor
            starButton.layer.borderWidth = 1
        }
        if filterObj.courseID == 4 {
            mainDizButton.backgroundColor = UIColor(named: "bg_button-color")
            mainDizButton.layer.borderColor = UIColor.orange.cgColor
            mainDizButton.layer.borderWidth = 1
        }
        if filterObj.courseID == 5 {
            sideButton.backgroundColor = UIColor(named: "bg_button-color")
            sideButton.layer.borderColor = UIColor.orange.cgColor
            sideButton.layer.borderWidth = 1
        }
        if filterObj.courseID == 6 {
            dessertButton.backgroundColor = UIColor(named: "bg_button-color")
            dessertButton.layer.borderColor = UIColor.orange.cgColor
            dessertButton.layer.borderWidth = 1
        }
        if filterObj.courseID == 7 {
            drinkButton.backgroundColor = UIColor(named: "bg_button-color")
            drinkButton.layer.borderColor = UIColor.orange.cgColor
            drinkButton.layer.borderWidth = 1
        }
        
        //MARK: Set data serving, PrepareTime, Calories
        if filterObj.serving != nil {
            servingSlider.value = Float(filterObj.serving ?? 0)
            ServingLabel.text = "\(filterObj.serving ?? 0)"
        }
        if filterObj.prepareTime != nil {
            minSlider.value = Float(filterObj.prepareTime ?? 0)
            minLabel.text = String(filterObj.prepareTime!) + " mins"
        }
        if filterObj.calories != nil {
            caloSlider.value = Float(filterObj.calories ?? 0)
            caloLabel.text = String(filterObj.calories!) + " cal"
        }
    }
    
    
    @IBAction func onApply(_ sender: Any) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let searchVC = sb.instantiateViewController(identifier: "SearchForDishViewController") as! SearchForDishViewController
//
//
        let servingValue = Int(servingSlider.value)
        if servingValue > 0 {
            filterObj.serving = servingValue
        }

        let minValue = Int(minSlider.value)
        if minValue > 0 {
            filterObj.prepareTime = minValue
        }

        let caloValue = Int(caloSlider.value)
        if caloValue > 0 {
            filterObj.calories = caloValue
        }
//
//        //MARK: passData
//        searchVC.filterObj = self.filterObj
        print(filterObj)
        //MARK: present
        dismiss(animated: true, completion: nil)
        onDishFilter?(filterObj)
        
        //self.present(searchVC, animated: true, completion: nil)
    }
    
    //MARK: Reset
    @IBAction func onReset(_ sender: Any) {
        breakfastButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        breakfastButton.titleLabel?.textColor = UIColor.systemGray
        breakfastButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        bunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        bunchButton.titleLabel?.textColor = UIColor.systemGray
        bunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        lunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        lunchButton.titleLabel?.textColor = UIColor.systemGray
        lunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        dinnerButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        dinnerButton.titleLabel?.textColor = UIColor.systemGray
        dinnerButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        sourpButton.titleLabel?.textColor = UIColor.systemGray
        sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        appertiezButton.titleLabel?.textColor = UIColor.systemGray
        appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        starButton.titleLabel?.textColor = UIColor.systemGray
        starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        mainDizButton.titleLabel?.textColor = UIColor.systemGray
        mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        sideButton.titleLabel?.textColor = UIColor.systemGray
        sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        dessertButton.titleLabel?.textColor = UIColor.systemGray
        dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
        drinkButton.titleLabel?.textColor = UIColor.systemGray
        drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
        
        servingSlider.value = 1
        ServingLabel.text = String(1)
        minSlider.value = 1
        minLabel.text = "5 mins"
        caloSlider.value = 0
        caloLabel.text = "0 cal"
        
        filterObj.mealID = nil
        filterObj.courseID = nil
        print(filterObj)
    }
    
    
    
    
    
    
    
    
    //MARK: SLIDER
    
    @IBAction func onServingSlider(_ sender: UISlider) {
        let servingValue = Int(servingSlider.value)
        ServingLabel.text = "\(servingValue)"
    }
    @IBAction func onMinSlider(_ sender: UISlider) {
        let minValue = Int(minSlider.value)
        minLabel.text = "\(minValue) mins"
    }
    
    @IBAction func onCaloSlider(_ sender: UISlider) {
        let caloValue = Int(caloSlider.value)
        caloLabel.text = "\(caloValue) cal"
    }
    
    
    
    //MARK: BUTTON
    @IBAction func onBreakFast(_ sender: Any) {
        if filterObj.mealID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.mealID = 1
                    
                    print(filterObj.mealID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.mealID = nil
                    print(filterObj.mealID ?? "")
                }
            }
        } else {
            if filterObj.mealID == 1 {
                filterObj.mealID = nil
                breakfastButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                breakfastButton.titleLabel?.textColor = UIColor.systemGray
                breakfastButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                breakfastButton.backgroundColor = UIColor(named: "bg_button-color")
                breakfastButton.layer.borderColor = UIColor.orange.cgColor
                breakfastButton.layer.borderWidth = 1
                
                bunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                bunchButton.titleLabel?.textColor = UIColor.systemGray
                bunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                lunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                lunchButton.titleLabel?.textColor = UIColor.systemGray
                lunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dinnerButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dinnerButton.titleLabel?.textColor = UIColor.systemGray
                dinnerButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.mealID = 1
            }
        }
    }
    @IBAction func onBunch(_ sender: Any) {
        if filterObj.mealID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.mealID = 2
                    print(filterObj.mealID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.mealID = nil
                    print(filterObj.mealID ?? "")
                }
            }
        } else {
            if filterObj.mealID == 2 {
                filterObj.mealID = nil
                bunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                bunchButton.titleLabel?.textColor = UIColor.systemGray
                bunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                breakfastButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                breakfastButton.titleLabel?.textColor = UIColor.systemGray
                breakfastButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                bunchButton.backgroundColor = UIColor(named: "bg_button-color")
                bunchButton.layer.borderColor = UIColor.orange.cgColor
                bunchButton.layer.borderWidth = 1
                
                lunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                lunchButton.titleLabel?.textColor = UIColor.systemGray
                lunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dinnerButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dinnerButton.titleLabel?.textColor = UIColor.systemGray
                dinnerButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.mealID = 2
            }
        }
    }
    
    @IBAction func onLunch(_ sender: Any) {
        if filterObj.mealID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.mealID = 3
                    print(filterObj.mealID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.mealID = nil
                    print(filterObj.mealID ?? "")
                }
            }
        } else {
            if filterObj.mealID == 3 {
                filterObj.mealID = nil
                lunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                lunchButton.titleLabel?.textColor = UIColor.systemGray
                lunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                breakfastButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                breakfastButton.titleLabel?.textColor = UIColor.systemGray
                breakfastButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                bunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                bunchButton.titleLabel?.textColor = UIColor.systemGray
                bunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                lunchButton.backgroundColor = UIColor(named: "bg_button-color")
                lunchButton.layer.borderColor = UIColor.orange.cgColor
                lunchButton.layer.borderWidth = 1
                
                dinnerButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dinnerButton.titleLabel?.textColor = UIColor.systemGray
                dinnerButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.mealID = 3
            }
        }
    }
    @IBAction func onDinner(_ sender: Any) {
        if filterObj.mealID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.mealID = 4
                    print(filterObj.mealID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.mealID = nil
                    print(filterObj.mealID ?? "")
                }
            }
        } else {
            if filterObj.mealID == 4 {
                filterObj.mealID = nil
                dinnerButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dinnerButton.titleLabel?.textColor = UIColor.systemGray
                dinnerButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                breakfastButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                breakfastButton.titleLabel?.textColor = UIColor.systemGray
                breakfastButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                bunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                bunchButton.titleLabel?.textColor = UIColor.systemGray
                bunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                lunchButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                lunchButton.titleLabel?.textColor = UIColor.systemGray
                lunchButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dinnerButton.backgroundColor = UIColor(named: "bg_button-color")
                dinnerButton.layer.borderColor = UIColor.orange.cgColor
                dinnerButton.layer.borderWidth = 1
                filterObj.mealID = 4
            }
        }
    }
    
    //MARK: Course
    @IBAction func onSoup(_ sender: Any) {
        if filterObj.courseID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.courseID = 1
                    print(filterObj.courseID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.courseID = nil
                    print(filterObj.courseID ?? "")
                }
            }
        } else {
            if filterObj.courseID == 1 {
                filterObj.courseID = nil
                sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sourpButton.titleLabel?.textColor = UIColor.systemGray
                sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                sourpButton.backgroundColor = UIColor(named: "bg_button-color")
                sourpButton.layer.borderColor = UIColor.orange.cgColor
                sourpButton.layer.borderWidth = 1
                
                appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                appertiezButton.titleLabel?.textColor = UIColor.systemGray
                appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                starButton.titleLabel?.textColor = UIColor.systemGray
                starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                mainDizButton.titleLabel?.textColor = UIColor.systemGray
                mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sideButton.titleLabel?.textColor = UIColor.systemGray
                sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dessertButton.titleLabel?.textColor = UIColor.systemGray
                dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                drinkButton.titleLabel?.textColor = UIColor.systemGray
                drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.courseID = 1
            }
        }
    }
    @IBAction func onAppetizer(_ sender: Any) {
        if filterObj.courseID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.courseID = 2
                    print(filterObj.courseID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.courseID = nil
                    print(filterObj.courseID ?? "")
                }
            }
        } else {
            if filterObj.courseID == 2 {
                filterObj.courseID = nil
                appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                appertiezButton.titleLabel?.textColor = UIColor.systemGray
                appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sourpButton.titleLabel?.textColor = UIColor.systemGray
                sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                appertiezButton.backgroundColor = UIColor(named: "bg_button-color")
                appertiezButton.layer.borderColor = UIColor.orange.cgColor
                appertiezButton.layer.borderWidth = 1
                
                starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                starButton.titleLabel?.textColor = UIColor.systemGray
                starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                mainDizButton.titleLabel?.textColor = UIColor.systemGray
                mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sideButton.titleLabel?.textColor = UIColor.systemGray
                sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dessertButton.titleLabel?.textColor = UIColor.systemGray
                dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                drinkButton.titleLabel?.textColor = UIColor.systemGray
                drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.courseID = 2
            }
        }
    }
    @IBAction func onStarter(_ sender: Any) {
        if filterObj.courseID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.courseID = 3
                    print(filterObj.courseID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.courseID = nil
                    print(filterObj.courseID ?? "")
                }
            }
        } else {
            if filterObj.courseID == 3 {
                filterObj.courseID = nil
                starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                starButton.titleLabel?.textColor = UIColor.systemGray
                starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sourpButton.titleLabel?.textColor = UIColor.systemGray
                sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                appertiezButton.titleLabel?.textColor = UIColor.systemGray
                appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                starButton.backgroundColor = UIColor(named: "bg_button-color")
                starButton.layer.borderColor = UIColor.orange.cgColor
                starButton.layer.borderWidth = 1
                
                mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                mainDizButton.titleLabel?.textColor = UIColor.systemGray
                mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sideButton.titleLabel?.textColor = UIColor.systemGray
                sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dessertButton.titleLabel?.textColor = UIColor.systemGray
                dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                drinkButton.titleLabel?.textColor = UIColor.systemGray
                drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.courseID = 3
            }
        }
    }
    @IBAction func onMainDish(_ sender: Any) {
        if filterObj.courseID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.courseID = 4
                    print(filterObj.courseID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.courseID = nil
                    print(filterObj.courseID ?? "")
                }
            }
        } else {
            if filterObj.courseID == 4 {
                filterObj.courseID = nil
                mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                mainDizButton.titleLabel?.textColor = UIColor.systemGray
                mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sourpButton.titleLabel?.textColor = UIColor.systemGray
                sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                appertiezButton.titleLabel?.textColor = UIColor.systemGray
                appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                starButton.titleLabel?.textColor = UIColor.systemGray
                starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                mainDizButton.backgroundColor = UIColor(named: "bg_button-color")
                mainDizButton.layer.borderColor = UIColor.orange.cgColor
                mainDizButton.layer.borderWidth = 1
                
                sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sideButton.titleLabel?.textColor = UIColor.systemGray
                sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dessertButton.titleLabel?.textColor = UIColor.systemGray
                dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                drinkButton.titleLabel?.textColor = UIColor.systemGray
                drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.courseID = 4
            }
        }
    }
    @IBAction func onSide(_ sender: Any) {
        if filterObj.courseID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.courseID = 5
                    print(filterObj.courseID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.courseID = nil
                    print(filterObj.courseID ?? "")
                }
            }
        } else {
            if filterObj.courseID == 5 {
                filterObj.courseID = nil
                sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sideButton.titleLabel?.textColor = UIColor.systemGray
                sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sourpButton.titleLabel?.textColor = UIColor.systemGray
                sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                appertiezButton.titleLabel?.textColor = UIColor.systemGray
                appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                starButton.titleLabel?.textColor = UIColor.systemGray
                starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                mainDizButton.titleLabel?.textColor = UIColor.systemGray
                mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                sideButton.backgroundColor = UIColor(named: "bg_button-color")
                sideButton.layer.borderColor = UIColor.orange.cgColor
                sideButton.layer.borderWidth = 1
                
                dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dessertButton.titleLabel?.textColor = UIColor.systemGray
                dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                drinkButton.titleLabel?.textColor = UIColor.systemGray
                drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.courseID = 5
            }
        }
    }
    @IBAction func onDessert(_ sender: Any) {
        if filterObj.courseID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.courseID = 6
                    print(filterObj.courseID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.courseID = nil
                    print(filterObj.courseID ?? "")
                }
            }
        } else {
            if filterObj.courseID == 6 {
                filterObj.courseID = nil
                dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dessertButton.titleLabel?.textColor = UIColor.systemGray
                dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sourpButton.titleLabel?.textColor = UIColor.systemGray
                sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                appertiezButton.titleLabel?.textColor = UIColor.systemGray
                appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                starButton.titleLabel?.textColor = UIColor.systemGray
                starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                mainDizButton.titleLabel?.textColor = UIColor.systemGray
                mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sideButton.titleLabel?.textColor = UIColor.systemGray
                sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dessertButton.backgroundColor = UIColor(named: "bg_button-color")
                dessertButton.layer.borderColor = UIColor.orange.cgColor
                dessertButton.layer.borderWidth = 1
                
                drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                drinkButton.titleLabel?.textColor = UIColor.systemGray
                drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                filterObj.courseID = 6
            }
        }
    }
    @IBAction func onDrinks(_ sender: Any) {
        if filterObj.courseID == nil {
            if let button = sender as? UIButton {
                if button.backgroundColor == UIColor(named: "bg_button-colorMain") {
                    button.backgroundColor = UIColor(named: "bg_button-color")
                    button.layer.borderColor = UIColor.orange.cgColor
                    button.layer.borderWidth = 1
                    
                    filterObj.courseID = 7
                    print(filterObj.courseID ?? "")
                }
                else if button.backgroundColor == UIColor(named: "bg_button-color") {
                    button.backgroundColor = UIColor(named: "bg_button-colorMain")
                    button.titleLabel?.textColor = UIColor.systemGray
                    button.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                    
                    filterObj.courseID = nil
                    print(filterObj.courseID ?? "")
                }
            }
        } else {
            if filterObj.courseID == 7 {
                filterObj.courseID = nil
                drinkButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                drinkButton.titleLabel?.textColor = UIColor.systemGray
                drinkButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
            } else {
                sourpButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sourpButton.titleLabel?.textColor = UIColor.systemGray
                sourpButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                appertiezButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                appertiezButton.titleLabel?.textColor = UIColor.systemGray
                appertiezButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                starButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                starButton.titleLabel?.textColor = UIColor.systemGray
                starButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                mainDizButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                mainDizButton.titleLabel?.textColor = UIColor.systemGray
                mainDizButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                sideButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                sideButton.titleLabel?.textColor = UIColor.systemGray
                sideButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                dessertButton.backgroundColor = UIColor(named: "bg_button-colorMain")
                dessertButton.titleLabel?.textColor = UIColor.systemGray
                dessertButton.layer.borderColor = UIColor(named: "bg_button-colorMain")?.cgColor
                
                drinkButton.backgroundColor = UIColor(named: "bg_button-color")
                drinkButton.layer.borderColor = UIColor.orange.cgColor
                drinkButton.layer.borderWidth = 1
                filterObj.courseID = 7
            }
        }
    }
}
