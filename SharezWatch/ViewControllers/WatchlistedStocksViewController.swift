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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createSnapshot()
    }
    
    //MARK: - Loading of Data using DiffableDataSource into the CollectionView
    
    lazy var collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Stock>(collectionView: watchlistCollection) { collectionView, indexPath, watchlistedStock in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "watchlistedStock", for: indexPath) as! WatchlistCollectionViewCell
        
        cell.watchlistTicker.text = watchlistedStock.ticker
        cell.watchlistPrice.text = self.priceFormatter.string(from: NSNumber(value: watchlistedStock.price))
        cell.watchlistChange.text = String(watchlistedStock.dayChange)
        cell.watchlistQuantity.text = "0"
        
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
