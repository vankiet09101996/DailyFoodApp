//
//  RecentlyNavigationController.swift
//  Demo DailyRecipe
//
//  Created by NEM on 20/06/2021.
//

import UIKit

class RecentlyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    func initViewController() {
        if let recentlyVC = self.mainStoryBoard.instantiateViewController(withIdentifier: "RecentlyViewController") as? RecentlyViewController {
            self.setViewControllers([recentlyVC], animated: true)
        }
    }
}
