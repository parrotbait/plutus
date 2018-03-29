//
//  String+Trim.swift
//  plutus
//
//  Created by Eddie Long on 23/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

extension String {
    mutating func trimWhitespace() {
        self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
