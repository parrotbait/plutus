//
//  FetcherProtocol.swift
//  plutus
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol FetcherProtocol {
    associatedtype ReturnType
    associatedtype ErrorType
    typealias CallResult = Result<ReturnType, ErrorType>

    typealias FetchCallback = ((_ result : CallResult) -> Void)
    func fetch(url: URL, completion: @escaping FetchCallback)
}
