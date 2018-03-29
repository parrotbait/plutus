//
//  UserCoin.swift
//  plutus
//
//  Created by Eddie Long on 28/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

struct UserCoin : Codable {
    let coin : Coin
    let currentPrice : CoinCurrentMarketData
}
