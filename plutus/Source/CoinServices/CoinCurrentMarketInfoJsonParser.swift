//
//  CoinPriceJsonParser.swift
//  plutus
//
//  Created by Eddie Long on 28/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import SWLogger

struct CoinCurrentMarketInfoJsonParser : JsonParser {
    typealias ReturnType = [CoinCurrentMarketData]!
    public func parse(_ jsonData : NSData) -> ReturnType {
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary {
                var coinList = [CoinCurrentMarketData]()
                if let display : NSDictionary = jsonResult["DISPLAY"] as? NSDictionary {
                    for keyValue in display {
                        if let coinName = keyValue.key as? String {
                            if let coinCurrencies = keyValue.value as? NSDictionary {
                                for currencyKV in coinCurrencies {
                                    if let currencyName = currencyKV.key as? String {
                                        if let currencyData = currencyKV.value as? NSDictionary {
                                            let hour24PricePeriod = CoinDailyMarketInfo.init(change: currencyData["CHANGE24HOUR"] as? String ?? "", changePercent: currencyData["CHANGEPCT24HOUR"] as? String ?? "", low: currencyData["LOW24HOUR"] as? String ?? "", high: currencyData["HIGH24HOUR"] as? String ?? "")
                                            let dayPricePeriod = CoinDailyMarketInfo.init(change: currencyData["CHANGEDAY"] as? String ?? "", changePercent: currencyData["CHANGEPCTDAY"] as? String ?? "", low: currencyData["LOWDAY"] as? String ?? "", high: currencyData["HIGHDAY"] as? String ?? "")
                                            let coinPrice = CoinCurrentMarketData.init(price: currencyData["PRICE"] as? String ?? "", currency: currencyName, symbol: coinName, change24Hour: hour24PricePeriod, changeDay: dayPricePeriod)
                                            coinList.append(coinPrice)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                return coinList
            }
        } catch {
            Log.e("Error!! Unable to parse json")
        }
        return nil;
    }
}
