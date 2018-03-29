//
//  CoinPricePeriod.swift
//  plutus
//
//  Created by Eddie Long on 24/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

typealias PriceChange = String
typealias PriceChangePercent = String
typealias PriceLow = String
typealias PriceHigh = String

struct CoinDailyMarketInfo : Codable {
    let change : PriceChange
    let changePercent : PriceChangePercent
    let low : PriceLow
    let high : PriceHigh
}
