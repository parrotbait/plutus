//
//  CoinPrice.swift
//  plutus
//
//  Created by Eddie Long on 24/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

typealias Currency = String
typealias Price = String

struct CoinCurrentMarketData : Codable {
    let price : Price
    let currency : Currency
    let symbol : String
    let change24Hour : CoinDailyMarketInfo
    let changeDay : CoinDailyMarketInfo
}
