//
//  SearchForDishHeaderTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 05/07/2021.
//

import UIKit

class SearchForDishHeaderTableViewCell: UITableViewCell {
    var buttonFilter : (() -> ()) = {}
    var buttonClear : (() -> ()) = {}
    @IBOutlet weak var mySearchBar: UISearchBar!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFilter(_ sender: Any) {
        buttonFilter()
    }
    @IBAction func onClear(_ sender: Any) {
        buttonClear()
    }
}
