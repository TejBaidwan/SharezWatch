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
    
    //Making sure the webview displayed fills the full width of the screen no matter the orientation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stockWeb.frame = self.view.bounds
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
}
