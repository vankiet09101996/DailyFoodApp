//
//  FavoritesNavigationController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 20/06/2021.
//

import UIKit

class FavoritesNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initViewController()
    }
    
    func initViewController() {
        if let favoritesVC = self.mainStoryBoard.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController {
            self.setViewControllers([favoritesVC], animated: true)
        }
    }
}
