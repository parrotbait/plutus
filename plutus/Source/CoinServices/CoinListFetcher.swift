//
//  CoinListFetcher
//  plutus
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct CoinListFetcher : FetcherProtocol {
    typealias ErrorType = LoadError
    
    typealias ReturnType = [Coin]
    typealias CoinListResult = CallResult
    typealias JsonParser = CoinListJsonParser
    
    enum FetcherType {
        case remote (RemoteFetcher<ReturnType, JsonParser>)
        case local (LocalFetcher<ReturnType, JsonParser>)
    }
    
    public var fetchType : FetcherType = .remote (RemoteFetcher<ReturnType, JsonParser>(parserIn: JsonParser()))
    //public var fetchType : FetcherType = .local (LocalFetcher<ReturnType, JsonParser>(parser: JsonParser(), jsonName: "CoinList"))
    
    public func fetch(url: URL, completion: @escaping FetchCallback) {
        switch fetchType {
        case .remote(let fetcher):
            fetcher.fetch(url: url, completion: completion);
        case .local(let fetcher):
            fetcher.fetch(url: url, completion: completion);
        }
    }
}
