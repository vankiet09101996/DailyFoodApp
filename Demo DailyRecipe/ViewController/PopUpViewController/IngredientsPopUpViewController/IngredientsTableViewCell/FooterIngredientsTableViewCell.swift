//
//  IngredientsTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 28/06/2021.
//

import UIKit

class FooterIngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
