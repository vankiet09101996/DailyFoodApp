//
//  HeaderSeeAllRecommendedTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 22/06/2021.
//

import UIKit

class HeaderSeeAllRecommendedTableViewCell: UITableViewCell {
    var buttonFilter : (() -> ()) = {}
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSetting(_ sender: Any) {
        buttonFilter()
    }
}
