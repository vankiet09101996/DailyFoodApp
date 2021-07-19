//
//  HeaderFavoriteTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 20/06/2021.
//

import UIKit

class HeaderFavoriteTableViewCell: UITableViewCell {
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
    @IBAction func onFilter(_ sender: Any) {
        buttonFilter()
    }
    
}
