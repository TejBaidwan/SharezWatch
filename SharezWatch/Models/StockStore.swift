//
//  StockStore.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-07.
//

import UIKit

/**
 This class represents the StockStore, which holds Stock objects and contains methods to allow for modification and persistence of them in the app
 */

class StockStore {
    
    //MARK: - Properties
    
    private var stocks: [Stock] = []
    
    var allStocks: [Stock] {
        return stocks
    }
    
    //MARK: - Get Document Directory Location and Check Watchlist
    
    var documentDirectory: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }

    func alreadyWatchlisted(stock: Stock) -> Bool {
        if stocks.contains(stock){
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Adding and Removing Stocks from the StockStore
    
    func addStock(stock: Stock){
        stocks.append(stock)
        saveStocks()
    }
    
    func removeStock(stock: Stock){
        for (index, storedStock) in stocks.enumerated(){
            if storedStock.ticker == stock.ticker {
                stocks.remove(at: index)
                saveStocks()
                return
            }
        }
    }
    
    // MARK: - Persisting of Stocks in the application
    
    func save(to url: URL){
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(stocks)
            try jsonData.write(to: url)
        } catch {
            print("Error encoding the JSON - \(error.localizedDescription)")
        }
    }
    
    //Getting Stock objects from the URL
    func retrieve(from url: URL){
        do{
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            stocks = try jsonDecoder.decode([Stock].self, from: jsonData)
        } catch {
            print("Error decoding the JSON - \(error.localizedDescription)")
        }
    }
    
    //Saving Stock objects to the document directory when watchlisted
    func saveStocks(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("watchlistedStocks.json")
        save(to: fileName)
    }
    
    //Fetching Stock objects from the document directory when loading content
    func getStocks(){
        guard let documentDirectory = documentDirectory else { return }
        let fileURL = documentDirectory.appendingPathComponent("watchlistedStocks.json")
        retrieve(from: fileURL)
    }
}
