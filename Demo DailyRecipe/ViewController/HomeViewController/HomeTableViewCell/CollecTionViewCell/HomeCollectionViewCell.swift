//
//  HomeCollectionViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 18/06/2021.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    var buttonIsLikedCallBack : (() -> ()) = {}
    @IBOutlet weak var viewAll: UIView!
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    //MARK: isLiked
    @IBOutlet weak var isLikedButton: UIButton!
    //MARK: rating
    @IBOutlet weak var ratingButton1: UIButton!
    @IBOutlet weak var ratingButton2: UIButton!
    @IBOutlet weak var ratingButton3: UIButton!
    @IBOutlet weak var ratingButton4: UIButton!
    @IBOutlet weak var ratingButton5: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewAll.layer.cornerRadius = 18
        
    
    }
    @IBAction func onIsLiked(_ sender: Any) {
        buttonIsLikedCallBack()
    }
}
