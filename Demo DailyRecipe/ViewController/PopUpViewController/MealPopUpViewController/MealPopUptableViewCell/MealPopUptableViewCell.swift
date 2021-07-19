//
//  MealPopUptableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 25/06/2021.
//

import UIKit

class MealPopUptableViewCell: UITableViewCell {

    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
