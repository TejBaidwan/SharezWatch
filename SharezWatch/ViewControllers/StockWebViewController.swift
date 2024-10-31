//
//  StockWebViewController.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-30.
//

import UIKit
import WebKit

/**
 This class represents the Stock webview which is shown when a watchlisted stock is double tapped
 */
class StockWebViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var stockWeb: WKWebView!
    
    //MARK: - Properties
    
    var stockToWebView: Stock?
    
    //MARK: View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sentStock = stockToWebView{
            
            //Creating a web URL using the stock ticker and loading a Yahoo Finance link
            if let webLink = URL(string: "https://finance.yahoo.com/quote/" + sentStock.ticker + "/"){
                let loadURL = URLRequest(url: webLink)
                stockWeb.load(loadURL)
                stockWeb.layer.cornerRadius = 5.0
                stockWeb.layer.masksToBounds = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
}
