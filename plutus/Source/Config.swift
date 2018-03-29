//
//  Config.swift
//  plutus
//
//  Created by Eddie Long on 17/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

struct Config {
    static let coinListUrl = "https://min-api.cryptocompare.com/data/all/coinlist"
    private static let coinPriceUrl_ = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=%@&tsyms=%@"
    static func coinPriceUrl(withCoins coins: String, andCurrencies currencies: String) -> String {
        return String.init(format: coinPriceUrl_, coins, currencies)
    }
    
    private static let coinHistoricalHour_ = "https://min-api.cryptocompare.com/data/histohour?fsym=%@&tsym=%@&limit=24&aggregate=1"
    private static let coinHistoricalWeek_ = "https://min-api.cryptocompare.com/data/histohour?fsym=%@&tsym=%@&limit=14&aggregate=12"
    private static let coinHistoricalMonth_ = "https://min-api.cryptocompare.com/data/histoday?fsym=%@&tsym=%@&limit=30&aggregate=1"
    private static let coinHistoricalYear_ = "https://min-api.cryptocompare.com/data/histoday?fsym=%@&tsym=%@&limit=13&aggregate=30"
    private static let coinHistoricalAllTime_ = "https://min-api.cryptocompare.com/data/histoday?fsym=%@&tsym=%@&limit=4000&aggregate=30"
    private static func getHistoricalUrl(_ period : PricePeriod) -> String {
        switch (period) {
        case .last24:
            return coinHistoricalHour_
        case .week:
            return coinHistoricalWeek_
        case .month:
            return coinHistoricalMonth_
        case .year:
            return coinHistoricalYear_
        case .allTime:
            return coinHistoricalAllTime_
        }
    }
    
    static func coinHistoricalUrl(period : PricePeriod, withCoins coins: String, andCurrencies currencies: String) -> String {
        return String.init(format: getHistoricalUrl(period), coins, currencies)
    }
    
    static let userJson = "user_data.json"
    static let defaultCurrency = "USD"
}
