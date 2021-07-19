//
//  BreakfastTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 21/06/2021.
//

import UIKit
import RealmSwift

class BreakfastTableViewCell: UITableViewCell {
    //MARK: IsLiked CallBack
    var buttonIsLikedCallBack : (() -> ()) = {}
    //MARK: IsRating CallBack
    var ratingButton1CallBack : (() -> ()) = {}
    var ratingButton2CallBack : (() -> ()) = {}
    var ratingButton3CallBack : (() -> ()) = {}
    var ratingButton4CallBack : (() -> ()) = {}
    var ratingButton5CallBack : (() -> ()) = {}
    
    
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var isLikedButton: UIButton!
    @IBOutlet weak var ratingButton1: UIButton!
    @IBOutlet weak var ratingButton2: UIButton!
    @IBOutlet weak var ratingButton3: UIButton!
    @IBOutlet weak var ratingButton4: UIButton!
    @IBOutlet weak var ratingButton5: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: onIsLiked
    @IBAction func onIsLiked(_ sender: Any) {
        buttonIsLikedCallBack()
    }
    
    //MARK: onRating
    @IBAction func onRating1(_ sender: Any) {
        ratingButton1CallBack()
    }
    @IBAction func onRating2(_ sender: Any) {
        ratingButton2CallBack()
    }
    @IBAction func onRating3(_ sender: Any) {
        ratingButton3CallBack()
    }
    @IBAction func onRating4(_ sender: Any) {
        ratingButton4CallBack()
    }
    @IBAction func onRating5(_ sender: Any) {
        ratingButton5CallBack()
    }
}
