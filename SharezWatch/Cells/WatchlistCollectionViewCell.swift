//
//  WatchlistCollectionViewCell.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-30.
//

import UIKit

/**
 This class represents the custom collection view cell for each watchlisted stock
 */
class WatchlistCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var watchlistTicker: UILabel!
    
    @IBOutlet weak var watchlistPrice: UILabel!
    
    @IBOutlet weak var watchlistChange: UILabel!
    
    @IBOutlet weak var watchlistQuantity: UILabel!
    
    //MARK: - Initializing Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
}
