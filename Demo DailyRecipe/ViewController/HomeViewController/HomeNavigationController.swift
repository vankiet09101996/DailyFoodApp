//
//  HomeNavigationController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 20/06/2021.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initViewController()
    }
    
    func initViewController() {
        if let homeVC = self.mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            self.setViewControllers([homeVC], animated: true)
        }
    }


}
