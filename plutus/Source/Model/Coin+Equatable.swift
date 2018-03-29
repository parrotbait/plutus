//
//  Weather+Equatable.swift
//  CorkWeather
//
//  Created by Eddie Long on 04/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.coinKey == rhs.coinKey && lhs.id == rhs.id;
    }
}
