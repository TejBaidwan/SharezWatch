//
//  StockDetailsViewController.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-26.
//

import UIKit
import WebKit

/**
 This class represents the details VC which shows more information about a stock when a searched stock is pressed in the search VC
 */
class StockDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var passedStockTicker: UILabel!
    
    @IBOutlet weak var passedStockCurrency: UILabel!
    
    @IBOutlet weak var passedStockPrice: UILabel!
    
    @IBOutlet weak var passedStockName: UILabel!
    
    @IBOutlet weak var passedStockDayRange: UILabel!
    
    @IBOutlet weak var stockQuantity: UITextField!
    
    @IBOutlet weak var stockValue: UILabel!
    
    @IBOutlet weak var stockWebView: WKWebView!
    
    //MARK: - Properties
    
    var stock: Stock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
