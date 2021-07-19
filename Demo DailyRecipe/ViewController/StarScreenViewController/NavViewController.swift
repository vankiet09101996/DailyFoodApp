//
//  NavViewController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 17/06/2021.
//
import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initViewController()
    }
    func initViewController() {
        if let mainSite = self.mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as? StarScreenViewController {
            self.setViewControllers([mainSite], animated: true)
        }
    }

}
extension UINavigationController {
    
    var mainStoryBoard: UIStoryboard {
        get {
            return UIStoryboard(name: "Main", bundle: nil)
        }
    }
}
