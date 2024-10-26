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
    
    //Currency formatter
    var priceFormatter: NumberFormatter = {
        let price = NumberFormatter()
        price.numberStyle = .currency
        price.locale = Locale.current
        return price
    }()
    
    //MARK: View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting the Stock passed over from the initial screen
        if let passedStock = stock{
            passedStockTicker.text = passedStock.ticker + " Details"
            passedStockCurrency.text = "Currency: \(passedStock.currency)"
            passedStockPrice.text = "Price: \(self.priceFormatter.string(from: NSNumber(value: passedStock.price)) ?? "$0.00")"
            passedStockName.text = "Name: \(passedStock.name)"
            passedStockDayRange.text = "Day Range:\(self.priceFormatter.string(from: NSNumber(value: passedStock.dayLow)) ?? "$0.00") - \(self.priceFormatter.string(from: NSNumber(value: passedStock.dayHigh)) ?? "$0.00")"
            
            //Creating a web URL using the stock sticker and loading a Yahoo Finance link
            if let webLink = URL(string: "https://finance.yahoo.com/quote/" + passedStock.ticker + "/"){
                let loadURL = URLRequest(url: webLink)
                stockWebView.load(loadURL)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
