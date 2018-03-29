//
//  CoinHistoricalHourFetcher.swift
//  plutus
//
//  Created by Eddie Long on 14/02/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

struct CoinHistoricalFetcher : FetcherProtocol {
    typealias ReturnType = CoinPricePeriod
    typealias ErrorType = LoadError
    
    typealias CoinPriceResult = CallResult
    typealias JsonParser = CoinHistoricalParser
    
    enum FetcherType {
        case remote (RemoteFetcher<ReturnType, JsonParser>)
        case local (LocalFetcher<ReturnType, JsonParser>)
    }
    
    public var fetchType : FetcherType = .remote (RemoteFetcher<ReturnType, JsonParser>(parserIn: JsonParser()))
    //public var fetchType : FetcherType = .local (LocalFetcher<ReturnType, JsonParser>(parser: JsonParser(), jsonName: "CoinPrice"))
    
    public func fetch(url: URL, completion: @escaping FetchCallback) {
        switch fetchType {
        case .remote(let fetcher):
            fetcher.fetch(url: url, completion: completion);
        case .local(let fetcher):
            fetcher.fetch(url: url, completion: completion);
        }
    }
}
