//
//  SeeAllRecommendedTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 22/06/2021.
//

import UIKit

class SeeAllRecommendedTableViewCell: UITableViewCell {
    var buttonIsLikedCallBack : (() -> ()) = {}
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    
    @IBOutlet weak var isLikedButton: UIButton!
    
    //MARK: rating Button
    @IBOutlet weak var ratingButton1: UIButton!
    @IBOutlet weak var ratingButton2: UIButton!
    @IBOutlet weak var ratingButton3: UIButton!
    @IBOutlet weak var ratingButton4: UIButton!
    @IBOutlet weak var ratingButton5: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myView.layer.cornerRadius = 18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onIsLiked(_ sender: Any) {
        buttonIsLikedCallBack()
    }
}
