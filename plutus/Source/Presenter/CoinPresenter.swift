//
//  CoinPresenter.swift
//  plutus
//
//  Created by Eddie Long on 22/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import SWLogger

class CoinPresenter : PresenterProtocol {
    let coinListFetcher = CoinListFetcher()
    let coinPriceFetcher = CoinCurrentMarketInfoFetcher()
    let coinMarketFetcher = CoinHistoricalFetcher()
    
    var user : User? = nil
    var coinPrices : [Coin: Dictionary<PricePeriod, CoinPricePeriod>]? = nil
    
    init() {
        self.user = User.fromJson(filename: Config.userJson)
    }
    
    func moveUserCoin(fromIndex: Int, toIndex: Int) {
        self.user!.coins.swapAt(fromIndex, toIndex)
        User.toJson(filename: Config.userJson, user: self.user!)
    }
    
    func getUserCoins() -> [UserCoin] {
        return self.user!.coins
    }
    
    func fetchHistoricalData(_ coin: Coin, _ period : PricePeriod, callback: @escaping CoinHistoricalDataFetched) {
        guard let url = URL(string: Config.coinHistoricalUrl(period: period, withCoins: coin.coinKey, andCurrencies: self.user?.currency ?? Config.defaultCurrency)) else {
            Log.e("Error: cannot create coinList URL")
            fatalError()
        }
        
        coinMarketFetcher.fetch(url: url) { [weak self] (result : CoinHistoricalFetcher.CoinPriceResult) in
            DispatchQueue.main.async {
                switch (result) {
                case .success(let historicalData):
                    self?.coinPrices?[coin] = [period: historicalData]
                    callback(Result.success(historicalData))
                    break
                case .failure(let error):
                    callback(Result.failure(error))
                    break
                }
            }
        }
    }
    
    func getCoinHistoricalPrice(_ coin: Coin, _ period : PricePeriod, callback: @escaping CoinHistoricalDataFetched) {
        if (self.coinPrices?.contains(where: { (coinPrice) -> Bool in
            return coinPrice.key == coin
        }) ?? false) {
            if let priceDict = self.coinPrices?[coin] {
                if let periodData = priceDict[period] {
                    callback(Result.success(periodData))
                }
            }
        }
        
        fetchHistoricalData(coin, period, callback: callback)
    }
    
    func addCoinsToUser(_ coins: [Coin], callback: @escaping OnCoinsAddedCallback) {
        if (coins.isEmpty) {
            Log.e("Expected coin list with at least 1 element")
            return
        }
        if (coins.isEmpty) {
            Log.w("No coins selected - returning immediately");
            callback(true);
            return;
        }
        
        fetchCoinPrices(coins: coins, currencies: [self.user?.currency ?? Config.defaultCurrency], { [weak self] (result : CoinCurrentMarketInfoFetcher.CoinPriceResult) in
            DispatchQueue.main.async {
                switch (result) {
                case .success(let coinPrices):
                    var userCoins = [UserCoin]()
                    for price in coinPrices {
                        for coin in coins {
                            if coin.coinKey == price.symbol {
                                let userCoin = UserCoin.init(coin: coin, currentPrice: price)
                                userCoins.append(userCoin)
                            }
                        }
                    }
                    
                    if !userCoins.isEmpty {
                        // Using if var here causes the array to be copied instead of referenced
                        self?.user?.coins.append(contentsOf: userCoins)
                        if let user = self?.user {
                            User.toJson(filename: Config.userJson, user: user)
                        }
                    }
                    callback(true);
                    break
                case .failure(let error):
                    callback(false);
                    break
                }
            }
        })
        
        // Persist - immediately
    }
    
    func removeUserCoin(_ coin : UserCoin) {
        self.user!.coins = self.user!.coins.filter() {$0.coin != coin.coin}
        User.toJson(filename: Config.userJson, user: self.user!)
    }
    
    func fetchCoinList(_ callback: @escaping CoinListFetcher.FetchCallback) {
        guard let url = URL(string: Config.coinListUrl) else {
            Log.e("Error: cannot create coinList URL")
            fatalError()
        }
        
        coinListFetcher.fetch(url: url, completion: callback)
    }
    
    func fetchCoinPrices(coins : [Coin], currencies: [Currency], _ callback: @escaping CoinCurrentMarketInfoFetcher.FetchCallback) {
        let coinList = coins.flatMap{coin in
            coin.coinKey
        }.joined(separator:",")
        let currencyList = currencies.flatMap({$0}).joined(separator: ",")
        let fullUrl = Config.coinPriceUrl(withCoins: coinList, andCurrencies: currencyList)
        guard let url = URL(string: fullUrl) else {
            Log.e("Error: cannot create price URL")
            fatalError()
        }
        
        coinPriceFetcher.fetch(url: url, completion: callback)
    }
}
