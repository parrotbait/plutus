//
//  CoinPricePoint.swift
//  plutus
//
//  Created by Eddie Long on 14/02/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

struct CoinPricePoint : Codable {
    let timestamp : UInt64
    let open : Float
    let close : Float
    let low : Float
    let high : Float
}
