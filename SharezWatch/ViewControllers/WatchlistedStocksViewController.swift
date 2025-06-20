//
//  WatchlistedStocksViewController.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-30.
//

import UIKit

/**
 This class represents the watchlist VC where the user can add and delete watchlisted stocks
 */
class WatchlistedStocksViewController: UIViewController {
    
    //MARK: - Oulets
    
    @IBOutlet weak var watchlistCollection: UICollectionView!
    
    //MARK: - Properties
    
    var stockStore = StockStore()
    
    //Currency formatter
    var priceFormatter: NumberFormatter = {
        let price = NumberFormatter()
        price.numberStyle = .currency
        price.locale = Locale.current
        return price
    }()
    
    //MARK: - View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchlistCollection.delegate = self
        createSnapshot()
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        watchlistCollection.addGestureRecognizer(singleTapGesture)
        
        //Create a LongPress gesture recognizer and apply it to the collection view
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        watchlistCollection.addGestureRecognizer(longPressGesture)
        
        //Create a DoubleTap gesture recognizer and apply it to the collection view
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        watchlistCollection.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        watchlistCollection.delegate = self
        createSnapshot()
    }
    
    //MARK: - Loading of Data using DiffableDataSource into the CollectionView
    
    lazy var collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Stock>(collectionView: watchlistCollection) { collectionView, indexPath, watchlistedStock in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "watchlistedStock", for: indexPath) as! WatchlistCollectionViewCell
        
        if let customFontContent = UIFont(name: "KulimPark-Bold", size: 17) {
            cell.watchlistPrice.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            cell.watchlistChange.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            cell.watchlistQuantity.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
        }
        if let customFontTitle = UIFont(name: "KulimPark-Bold", size: 32) {
            cell.watchlistTicker.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFontTitle)
        }
        
        cell.watchlistTicker.text = watchlistedStock.ticker
        cell.watchlistPrice.text = "Price: " + (self.priceFormatter.string(from: NSNumber(value: watchlistedStock.price)) ?? "0.00")
        cell.watchlistChange.text = "Change %: " + String(watchlistedStock.dayChange)
        cell.watchlistQuantity.text = "Quantity: " + String(watchlistedStock.quantity)
        
        if(watchlistedStock.dayChange < 0) {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.green
        }
        
        return cell
    }
    
    //Creating the snapshot using DiffableDataSource
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Stock>()
        snapshot.appendSections([.main])
        snapshot.appendItems(stockStore.allStocks)
        collectionViewDataSource.apply(snapshot)
    }
    
    // MARK: - Gesture Handlers
    
    //Handle Single Tap for updating stock quantity
    @objc func handleSingleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: watchlistCollection)
        if let indexPath = watchlistCollection.indexPathForItem(at: location) {
            let selectedStock = stockStore.allStocks[indexPath.item]

            //Create an alert with a text field
            let alertController = UIAlertController(title: "Update Quantity",
                                                    message: "Enter new quantity for \(selectedStock.ticker)",
                                                    preferredStyle: .alert)

            //Add a text field to the alert for entering quantity
            alertController.addTextField { textField in
                textField.keyboardType = .decimalPad
                textField.placeholder = "Enter quantity"
                textField.text = "\(selectedStock.quantity)" // Prefill with current quantity
            }

            //Confirm action to update quantity
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                if let text = alertController.textFields?.first?.text, let newQuantity = Double(text) {
                    self.stockStore.updateStock(ticker: selectedStock.ticker, newQuantity: newQuantity)
                    self.createSnapshot()
                }
            }

            //Cancel action
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(confirmAction)

            //Present the alert
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //This method gets the item in the collectionview when long pressed, and creats an alert which allows for deletion of it from the watchlist
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            
            //Get the Stock object which is long pressed
            let location = gestureRecognizer.location(in: watchlistCollection)
            if let indexPath = watchlistCollection.indexPathForItem(at: location) {
                let stockToRemove = stockStore.allStocks[indexPath.item]
                
                //Create an Alert Controller with options to accept or decline deletion
                let alertController = UIAlertController(title: "Delete Stock?", message: "Confirm deletion of \(stockToRemove.ticker)?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    
                    //If the deletion is confirmed then remove the Stock from the saved directory and refresh the page
                    self.stockStore.removeStock(stock: stockToRemove)
                    self.createSnapshot()
                }))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //This method gets the item in the collectionview when double tapped, and segues to the web VC which shows a full-screen webview for the stock from Yahoo Finance
    @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            
            //Get the Stock object which is double tapped
            let location = gestureRecognizer.location(in: watchlistCollection)
            if let indexPath = watchlistCollection.indexPathForItem(at: location) {
                let stockToView = stockStore.allStocks[indexPath.item]
                
                //Create a segue to the webview VC and pass over the selected stock
                let stockWebVC = storyboard?.instantiateViewController(withIdentifier: "StockWebViewController") as! StockWebViewController
                stockWebVC.stockToWebView = stockToView
                present(stockWebVC, animated: true, completion: nil)
            }
    }
    
}

//MARK: - Extension Methods for setting the CollectionView sizes

extension WatchlistedStocksViewController: UICollectionViewDelegateFlowLayout{
    
    //Line spacing in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //Interim spacing in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //Determining size for collection view cells based on landscape or portrait orientation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.frame.width
        let numberOfItems: CGFloat
        
        //Set the number of items in each row to 3 in portrait or 5 in landscape
        if UIDevice.current.orientation.isLandscape {
            numberOfItems = 4
        } else {
            numberOfItems = 2
        }
        
        //Calculate item width and height
        let spacing = (numberOfItems - 1) * 10
        let itemWidth = (collectionViewWidth - spacing) / numberOfItems

        return CGSize(width: itemWidth, height: itemWidth)
        
    }
}
