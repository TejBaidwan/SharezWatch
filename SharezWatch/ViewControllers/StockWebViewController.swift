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
    
    
    
}
