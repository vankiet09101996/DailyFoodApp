//
//  ButtonIngredientTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 28/06/2021.
//

import UIKit

class ButtonIngredientTableViewCell: UITableViewCell {
    var buttonCancel : (() -> ()) = {}
    var buttonOK : (() -> ()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onCancel(_ sender: Any) {
        buttonCancel()
    }
    @IBAction func onOK(_ sender: Any) {
        buttonOK()
    }
}
