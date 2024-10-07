//
//  StockSearchViewController.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-07.
//

import UIKit

/**
 This class represents the code for the StockSearch VC and handling user searches and fetching data using their entry with StockData.org API
 */
class StockSearchViewController: UIViewController {
    
    //MARK: - Oulets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var stocks: [Stock] = []
    var stockStore: StockStore!
    
    //MARK: View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createSnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Loading of Data using DiffableDatSource in the tableview
    lazy var tableDataSource = UITableViewDiffableDataSource<Section, Stock>(tableView: tableView) {
        tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockSearchTableviewCell
        cell.stockTicker.text = itemIdentifier.ticker
        cell.stockName.text = itemIdentifier.name
        cell.stockPrice.text = String(itemIdentifier.price)
        
        return cell
    }
    
    //Creating the snapshot using DiffableDataSource
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Stock>()
        snapshot.appendSections([.main])
        snapshot.appendItems(stocks)
        tableDataSource.apply(snapshot)
    }
    
    //MARK: - Creating and Fetching of Stock objects
    
    //Creating the URL, including the users search, and then creating the API query URL
    func createStockURL(from search: String) -> URL? {
        guard let cleanURL = search.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return nil}
        var urlString = "https://api.stockdata.org/v1/data/quote?symbols="
        urlString = urlString.appending("\(cleanURL)")
        urlString = urlString.appending("&api_token=\(API_KEY)")
        
        return URL(string: urlString)
    }
    
    //Fetching stocks from the URL retrieved by the users search bar entry
    func fetchStocks(from url: URL){
        let stockTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            if let dataError = error {
                print("Error has occurred - \(dataError.localizedDescription)")
            }else {
                do{
                    guard let someData = data else {
                        return
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode(Stocks.self, from: someData)
                    self.stocks = downloadedResults.results
                    
                    DispatchQueue.main.async {
                        self.createSnapshot()
                    }
                }catch{
                    print("A decoding error has occurred \(error.localizedDescription)")
                }
                
            }
        }
        stockTask.resume()
    }

}
