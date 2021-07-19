//
//  FrenchToastTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 22/06/2021.
//

import UIKit

class FrenchToastTableViewCell: UITableViewCell {
    //MARK: onIsLiked
    var buttonIsLikedCallBack : (() -> ()) = {}
    @IBOutlet weak var isLikeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onIsLiked(_ sender: Any) {
        buttonIsLikedCallBack()
    }
}
