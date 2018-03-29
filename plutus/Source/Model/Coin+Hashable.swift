//
//  Coin+Hashable.swift
//  plutus
//
//  Created by Eddie Long on 20/02/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

extension Coin: Hashable {
    var hashValue: Int {
        return coinKey.hashValue ^ id.hashValue &* 16777619
    }
}
