//
//  CoinPriceHourly.swift
//  plutus
//
//  Created by Eddie Long on 14/02/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

struct CoinPricePeriod : Codable {
    let prices : [CoinPricePoint]
    let isDirect : Bool
}
