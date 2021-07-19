//
//  HeaderRecentlyTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 20/06/2021.
//

import UIKit

class HeaderRecentlyTableViewCell: UITableViewCell {

    @IBOutlet weak var mySearchBar: UISearchBar!
    var buttonFilter : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onFilter(_ sender: Any) {
        buttonFilter()
    }
}
