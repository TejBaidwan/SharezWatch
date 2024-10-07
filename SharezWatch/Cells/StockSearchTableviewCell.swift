//
//  StockSearchTableviewCell.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-07.
//

import UIKit

/**
 This class represents the custom tableview cell which displays the stock information from the users search
 */
class StockSearchTableviewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var stockTicker: UILabel!
    
    @IBOutlet weak var stockName: UILabel!
    
    @IBOutlet weak var stockPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
