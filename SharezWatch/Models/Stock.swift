//
//  Stock.swift
//  SharezWatch
//
//  Created by Tejvir Baidwan on 2024-10-07.
//

import Foundation

//Enumeration
enum Section {
    case main
}

//Breaking down the JSON response into the meta and data return, in which the data array contains the Stocks
struct StockResponse: Codable {
    let meta: Meta
    let data: [Stock]
}

//Meta data detruned
struct Meta: Codable {
    let requested: Int
    let returned: Int
}

//A Stock struct which represents the Stock object returned from StockData.org JSON query
struct Stock: Codable, Hashable {
    let ticker: String
    let name: String
    let exchangeShort: String?
    let exchangeLong: String?
    let micCode: String
    let currency: String
    let price: Double
    let dayHigh: Double
    let dayLow: Double
    let dayOpen: Double
    let week52High: Double
    let week52Low: Double
    let marketCap: Double?
    let previousClosePrice: Double
    let previousClosePriceTime: String
    let dayChange: Double
    let volume: Int
    let isExtendedHoursPrice: Bool
    let lastTradeTime: String
    var quantity: Double = 0.0
    
    // Coding keys to map JSON keys to property names
    enum CodingKeys: String, CodingKey {
        case ticker
        case name
        case exchangeShort = "exchange_short"
        case exchangeLong = "exchange_long"
        case micCode = "mic_code"
        case currency
        case price
        case dayHigh = "day_high"
        case dayLow = "day_low"
        case dayOpen = "day_open"
        case week52High = "52_week_high"
        case week52Low = "52_week_low"
        case marketCap = "market_cap"
        case previousClosePrice = "previous_close_price"
        case previousClosePriceTime = "previous_close_price_time"
        case dayChange = "day_change"
        case volume
        case isExtendedHoursPrice = "is_extended_hours_price"
        case lastTradeTime = "last_trade_time"
    }
}

//Creating a collection of Stock objects
struct Stocks: Codable {
    var results: [Stock]
}

