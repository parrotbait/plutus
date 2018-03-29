//
//  PresenterProtocol.swift
//  plutus
//
//  Created by Eddie Long on 22/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

protocol PresenterProtocol {
    func fetchCoinList(_ callback : @escaping CoinListFetcher.FetchCallback)
    
    func moveUserCoin(fromIndex: Int, toIndex: Int)
    func getUserCoins() -> [UserCoin]
    typealias OnCoinsAddedCallback = ((_ : Bool) -> Void)
    mutating func addCoinsToUser(_ coins: [Coin], callback: @escaping OnCoinsAddedCallback)
    typealias CoinHistoricalDataFetched = ((Result<CoinPricePeriod, LoadError>) -> Void)
    func getCoinHistoricalPrice(_ coin: Coin, _ period : PricePeriod, callback: @escaping CoinHistoricalDataFetched);
    func removeUserCoin(_ coin : UserCoin)
}
