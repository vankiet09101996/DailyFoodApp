//
//  SearchTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 18/06/2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var mySearchBar: UISearchBar!
    override func awakeFromNib() {
        super.awakeFromNib()
        mySearchBar.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onSetting(_ sender: Any) {
    }
    
}
