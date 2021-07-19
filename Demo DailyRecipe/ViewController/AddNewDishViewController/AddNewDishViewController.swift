//
//  AddNewDishViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 24/06/2021.
//

import UIKit
import RealmSwift
class AddNewDishViewController: UIViewController {
    
    //MARK: outLet Button
    @IBOutlet weak var mealButton: UIButton! {
        didSet{
            mealButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var dropMealButton: UIButton!{
        didSet{
            dropMealButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var courseButton: UIButton!{
        didSet{
            courseButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet var dropCourseButton: UIButton!{
        didSet{
            dropCourseButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var ingredientsButton: UIButton!{
        didSet{
            ingredientsButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet var dropIngredientButton: UIButton!{
        didSet{
            dropIngredientButton.layer.cornerRadius = 5
        }
    }
    //MARK: Variables
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height / 2
    let datePicker = UIDatePicker()
    //MARK: textField
    @IBOutlet weak var urlImageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var servingTextField: UITextField!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var calTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var DescriptionTextField: UITextField!
    //MARK: View
    @IBOutlet var mealView: UIStackView!{
        didSet{
            mealView.layer.cornerRadius = 5
            mealView.layer.borderColor = UIColor.orange.cgColor
            mealView.layer.borderWidth = 1
        }
    }
    @IBOutlet var courseView: UIStackView!{
        didSet{
            courseView.layer.cornerRadius = 5
            courseView.layer.borderColor = UIColor.orange.cgColor
            courseView.layer.borderWidth = 1
        }
    }
    @IBOutlet var ingreditents: UIStackView!{
        didSet{
            ingreditents.layer.cornerRadius = 5
            ingreditents.layer.borderColor = UIColor.orange.cgColor
            ingreditents.layer.borderWidth = 1
        }
    }
    //MARK: Button
    @IBOutlet weak var okButton: UIButton!{
        didSet {
            okButton.layer.cornerRadius = 5
            okButton.layer.borderColor = UIColor(named: "bg_button-color")?.cgColor
            okButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var cancelButton: UIButton!{
        didSet {
            cancelButton.layer.cornerRadius = 5
//            cancelButton.layer.borderColor = UIColor.black.cgColor
//            cancelButton.layer.borderWidth = 1
        }
    }
    
    var dishObj : DishObj?
    var mealSelected: MealObj?
    var courseSelected: CourseObj?
    var ingredientsSelected: [IngredientsObj]?
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        let realm = try! Realm()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var resultDay = formatter.string(from: date)
        let updatedDate =  Date()
        resultDay = updatedDate.convertToString()
        print(resultDay)
        let todayEvent = realm.objects(DishObj.self).filter("viewDate == '\(resultDay)'")
        print(todayEvent)
    }
    
    //MARK: DatePickerView
    func createDatePicker(){
        //toolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(OkPressed))
        doneButton.tintColor = UIColor.black
        toolBar.setItems([doneButton], animated: true)
        //assign toolBar
        dateTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    @objc func OkPressed() {
        let fomatter = DateFormatter()
        fomatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = fomatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    
    //MARK: Action Pop up
    @IBAction func onMeal(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let MealPopUpVC = sb.instantiateViewController(identifier: "MealPopUpViewController" ) as! MealPopUpViewController
        MealPopUpVC.onMealSelectd = { [weak self] meal in
            guard let self = self else { return }
            self.mealSelected = meal
            self.mealButton.setTitle(meal?.name ?? "", for: .normal)
         }
        MealPopUpVC.mealSelected = self.mealSelected
        self.present(MealPopUpVC, animated: true, completion: nil)
    }
    
    @IBAction func onCourse(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let CoursePopUpVC = sb.instantiateViewController(identifier: "CoursePopUpViewController" ) as! CoursePopUpViewController
        CoursePopUpVC.onCourseSelectd = { [weak self] course in
                guard let self = self else { return }
                self.courseSelected = course
                self.courseButton.setTitle(course?.name ?? "", for: .normal)
            }
        CoursePopUpVC.courseSelected = self.courseSelected
        self.present(CoursePopUpVC, animated: true, completion: nil)
    }
    
    @IBAction func onIngredients(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let IngredientsVC = sb.instantiateViewController(identifier: "IngredientsPopUpViewController" ) as! IngredientsPopUpViewController
        IngredientsVC.onIngredientsSelected = { [weak self] ingredients in
            guard let self = self else { return }
            var countPen = ""
            ingredients!.forEach { ingredient in
                countPen += ingredient.name! + ", "
            }
            self.ingredientsButton.setTitle(String(describing: countPen), for: .normal)
            self.ingredientsSelected = ingredients
        }
        IngredientsVC.inngredientsSelected = self.ingredientsSelected
        self.present(IngredientsVC, animated: true, completion: nil)
    }
    
    //MARK: Action Cancel - OK
    @IBAction func onCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onOk(_ sender: Any) {
        guard let urlImage = urlImageTextField.text, urlImage.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter image url")
            return
        }
        guard let name = nameTextField.text, name.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter dish name")
            return
        }
        //MARK: Int
        guard let serving = servingTextField.text, serving.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter the waiter number")
            return
        }
        //MARK: date
        guard let min = minTextField.text, min.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter minutes")
            return
        }
        //MARK: Int
        guard let calo = calTextField.text, calo.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter the number of calories in the dish")
            return
        }
        guard let date = dateTextField.text, date.count > 0 else {
            self.showAlert(title: "Error", message: "Please enter date")
            return
        }
        guard let Description = DescriptionTextField.text, Description.count > 0 else {
            self.showAlert(title: "Error", message: "Please describe this dish")
            return
        }
        
        
        
        
        
        let dishObj = DishObj()
        dishObj.id = dishObj.IncrementaID()
        let updatedDate =  Date()
//        dishObj.prepareTime = updatedDate.convertToString()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let dateFromString = dateFormatter.date(from: date)
//        dishObj.viewDate = dateFromString!
        dishObj.viewDate = updatedDate.convertToString()
        //MARK: add textField
        dishObj.setValue(urlImage, forKey: "urlDish")
        
        dishObj.setValue(name, forKey: "name")
        
        dishObj.setValue(serving, forKey: "serving")
        
        dishObj.setValue(min, forKey: "prepareTime")
        
        dishObj.setValue(calo, forKey: "calories")
        
        dishObj.setValue(date, forKey: "viewDate")
        
        dishObj.setValue(Description, forKey: "descriptions")
        
        dishObj.setValue(mealSelected?.id, forKey: "mealID")
        dishObj.setValue(courseSelected?.id, forKey: "courseID")
        
        guard let ingredients = self.ingredientsSelected, ingredients.count > 0 else {
            return
        }
        var ingredientIDs = ""
        for (index, item) in ingredients.enumerated(){
            if index == ingredients.count - 1 {
                ingredientIDs += "\(item.id)"
            }else {
                ingredientIDs += "\(item.id),"
            }
        }
        dishObj.setValue(ingredientIDs, forKey: "Ingredients")

        
        
        
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(dishObj)
                print("Added \(String(describing: dishObj.name)) to Realm DataBase")
            }
        } catch {
            print(error)
        }
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let alert = UIAlertController(title: "successfully",
                                      message: "successfully added item",
                                      preferredStyle: .alert)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true) {
        }
    
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
