//
//  Coin+Comparable.swift
//  plutus
//
//  Created by Eddie Long on 23/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

extension Coin: Comparable {
    static func < (lhs: Coin, rhs: Coin) -> Bool {
        if lhs.sort != rhs.sort {
            return lhs.sort < rhs.sort
        }
        return lhs.fullname < rhs.fullname
    }
}
