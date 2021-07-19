//
//  DirectionsIngredientsTableViewCell.swift
//  Demo DailyRecipe
//
//  Created by NEM on 22/06/2021.
//

import UIKit

class DirectionsIngredientsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var iconImage:[String] = ["detail_ic1.png", "detail_ic2.png", "detail_ic3.png", "detail_ic4.png", "detail_ic5.png", "detail_ic6.png"]
    @IBOutlet weak var myCollectionView: UICollectionView! {
        didSet{
            self.myCollectionView.delegate = self
            self.myCollectionView.dataSource = self
            setLayout()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: self.myCollectionView.frame.width/6 , height: self.myCollectionView.frame.height + 20)
        self.myCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DirectionIngredientsCollectionViewCell", for: indexPath) as! DirectionIngredientsCollectionViewCell
        cell.myImage.image = UIImage(named: iconImage[indexPath.row])
        return cell
    }

}
