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
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var stocks: [Stock] = []
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
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        tableView.delegate = self
        createSnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Loading of Data using DiffableDatSource in the tableview
    lazy var tableDataSource = UITableViewDiffableDataSource<Section, Stock>(tableView: tableView) {
        tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockSearchTableviewCell
        
        //Creating font style for the cell labels using my custom font from Google
        if let customFontContent = UIFont(name: "KulimPark-Bold", size: 17) {
            cell.stockTicker.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            cell.stockName.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
            cell.stockPrice.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFontContent)
        }
        
        //Settng the label values
        cell.stockTicker.text = itemIdentifier.ticker
        cell.stockName.text = itemIdentifier.name
        cell.stockPrice.text = self.priceFormatter.string(from: NSNumber(value: itemIdentifier.price))
        
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
                    let downloadedResults = try jsonDecoder.decode(StockResponse.self, from: someData)
                    self.stocks = downloadedResults.data
                    
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
    
    //MARK: - Passing the Stock object details to the StockDetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
        let chosenStock = stocks[selectedIndex.row]
        
        let destinationVC = segue.destination as! StockDetailsViewController
        destinationVC.stock = chosenStock

    }

}

//MARK: - Extension Methods for SearchBar and TableView Cells

//Parsing and fetching movies from search bar text
extension StockSearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        if let stockURL = createStockURL(from: searchText){
            fetchStocks(from: stockURL)
        }
        
        //Resign keyboard
        searchBar.resignFirstResponder()
    }
}

//Handling the tapping of tableview cells
extension StockSearchViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
