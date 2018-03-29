//
//  JsonParser.swift
//  plutus
//
//  Created by Eddie Long on 24/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

protocol JsonParser {
    associatedtype ReturnType
    func parse(_ jsonData : NSData) -> ReturnType
}
