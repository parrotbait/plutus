//
//  Result.swift
//  plutus
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

enum Result<Value, ErrorType> {
    case success(Value)
    case failure(ErrorType)
}
