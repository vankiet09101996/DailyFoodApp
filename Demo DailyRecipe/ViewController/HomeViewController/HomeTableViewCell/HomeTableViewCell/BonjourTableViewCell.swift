//
//  HeaderTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 18/06/2021.
//

import UIKit
import RealmSwift

class BonjourTableViewCell: UITableViewCell {

    @IBOutlet weak var mySearchBar: UISearchBar!
    var buttonFilter : (() -> ()) = {}
    var searchBarFilter : (() -> ()) = {}
    var allFilterObjs :[DishObj]?
    var searching = false
    override func awakeFromNib() {
        super.awakeFromNib()
        mySearchBar.delegate = self
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

extension BonjourTableViewCell: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let realm = try! Realm()
//        let predicate = NSPredicate(format: "name contains[c] %@", searchBar)
        allFilterObjs = realm.objects(DishObj.self).filter("name contains[cd]  '\(searchBar.text ?? "")'").toArray(ofType: DishObj.self)
//        self.mySearchBar.endEditing(true)
        searchBarFilter()
    }
}
