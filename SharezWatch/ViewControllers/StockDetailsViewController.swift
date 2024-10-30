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
    
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var stockValue: UILabel!
    
    @IBOutlet weak var stockWebView: WKWebView!
    
    
    //MARK: - Properties
    
    var stock: Stock?
    var stockStore: StockStore!
    
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
        
        //Creating font style for the cell labels using my custom font from Google
        if let customFontContent = UIFont(name: "KulimPark-Bold", size: 17) {
            passedStockCurrency.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            passedStockPrice.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            passedStockName.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            passedStockDayRange.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            stockValue.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
        }
        
        if let customFontContent = UIFont(name: "KulimPark-Bold", size: 24) {
            passedStockTicker.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: customFontContent)
        }
        
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
                stockWebView.layer.cornerRadius = 10.0 
                stockWebView.layer.masksToBounds = true
            }
            
            //Setting the initial position of the webview off screen to the left
            let startingPosition = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            stockWebView.transform = startingPosition
                    
            //Creating a gesture recognizer for the swiping of left to right (appear) for the webview
            let swipeGestureAppear = UISwipeGestureRecognizer(target: self, action: #selector(appearSwipe))
            swipeGestureAppear.direction = .right
            view.addGestureRecognizer(swipeGestureAppear)
            
            //Creating a gesture recognizer for the swiping of right to left (disappear) for the webview
            let swipeGestureDisappear = UISwipeGestureRecognizer(target: self, action: #selector(disappearSwipe))
            swipeGestureDisappear.direction = .left
            view.addGestureRecognizer(swipeGestureDisappear)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Gesture Methods
    
    //Method to react to the swiping of the webview onto the screen
    @objc func appearSwipe(_ gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 1.0) {
        self.stockWebView.transform = .identity
        }
    }
    
    //Method to react to the swiping of the webview off the screen
    @objc func disappearSwipe(_ gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 1.0) {
            let moveAway = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
            self.stockWebView.transform = moveAway
        }
    }
    
    //MARK: - Action handler for the calculate stock value button
    
    @IBAction func calculateValue(_ sender: UIButton) {
        
        if let text = stockQuantity.text, !text.isEmpty {
            let ticker = stock?.ticker ?? "X"
            let shares = Double(text) ?? 0.0
            let stockPrice = stock?.price ?? 0.0
                
            // Format total value as currency
            let formattedValue = priceFormatter.string(from: NSNumber(value: shares * stockPrice)) ?? "$0.00"

            stockValue.text = "\(text) shares of \(ticker) is worth \(formattedValue)"
        } else {
            stockValue.text = "Please enter a share quantity"
        }
    }
    
    //MARK: - Handling a Stock being Watchlisted
    
    @IBAction func watchlistStock(_ sender: UIBarButtonItem) {
        
        guard let sentStock = stock else {
            return
        }
        
        //Creating the CustomDialog
        let animationBanner = CustomAnimation()
        animationBanner.frame = view.bounds
        animationBanner.isOpaque = false
        
        view.addSubview(animationBanner)
        view.isUserInteractionEnabled = false
        
        //Check is the stock has already been watchlisted and display an according banner
        if stockStore.alreadyWatchlisted(stock: sentStock) {
            animationBanner.dialogTitle = "\(sentStock.ticker) Already Saved" as NSString
            animationBanner.dialogFillColour = UIColor.black
            animationBanner.imageType = "exclamationmark.triangle"
        } else {
            stockStore.addStock(stock: sentStock)
            animationBanner.dialogTitle = "\(sentStock.ticker) Watchlisted!" as NSString
        }
        
        animationBanner.showDialog()
        
        let delay = 1.50
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}
