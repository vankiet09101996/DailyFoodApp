//
//  HeaderFootTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 18/06/2021.
//

import UIKit

class HeaderRecommendedTableViewCell: UITableViewCell {
    var buttonPressed : (() -> ()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSeeAll(_ sender: Any) {
        buttonPressed()
    }
}
