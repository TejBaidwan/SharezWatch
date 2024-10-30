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
        
        createSnapshot()
        watchlistCollection.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createSnapshot()
        watchlistCollection.delegate = self
    }
    
    //MARK: - Loading of Data using DiffableDataSource into the CollectionView
    
    lazy var collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Stock>(collectionView: watchlistCollection) { collectionView, indexPath, watchlistedStock in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "watchlistedStock", for: indexPath) as! WatchlistCollectionViewCell
        
        cell.watchlistTicker.text = watchlistedStock.ticker
        cell.watchlistPrice.text = "Price: " + (self.priceFormatter.string(from: NSNumber(value: watchlistedStock.price)) ?? "0.00")
        cell.watchlistChange.text = "Change: " + String(watchlistedStock.dayChange)
        cell.watchlistQuantity.text = "Quantity: " + "0"
        
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
    
}

//MARK: - Extension Methods for setting the CollectionView sizes

extension WatchlistedStocksViewController: UICollectionViewDelegateFlowLayout{
    
    //Line spacing in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //Interim spacing in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
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
        let spacing = (numberOfItems - 1) * 1
        let itemWidth = (collectionViewWidth - spacing) / numberOfItems
        let itemHeight = itemWidth

        return CGSize(width: itemWidth, height: itemHeight)
        
    }
}
