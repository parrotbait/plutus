//
//  CoinHistoricalHourParser.swift
//  plutus
//
//  Created by Eddie Long on 14/02/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import SWLogger

struct CoinHistoricalParser : JsonParser {
    typealias ReturnType = CoinPricePeriod!
    public func parse(_ jsonData : NSData) -> ReturnType {
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary {

                var isDirect = false
                if let conversionType = jsonResult["ConversionType"] as? NSDictionary {
                    if let type = conversionType["type"] as? String {
                        isDirect = type == "direct"
                    }
                }
                
                var pricePoints = [CoinPricePoint]()
                if let priceData = jsonResult["Data"] as? NSArray {
                    for price in priceData {
                        if let coinValues = price as? NSDictionary {
                            let newPoint = CoinPricePoint.init(timestamp: coinValues["time"] as? UInt64 ?? 0, open: coinValues["open"] as? Float ?? 0.0, close:  coinValues["close"] as? Float ?? 0.0, low:  coinValues["low"] as? Float ?? 0.0, high:  coinValues["high"] as? Float ?? 0.0)
                            pricePoints.append(newPoint)
                        }
                    }
                }
                if (pricePoints.isEmpty) {
                    return nil
                }
                return CoinPricePeriod.init(prices: pricePoints, isDirect: isDirect)
            }
        } catch {
            Log.e("Error!! Unable to parse json")
        }
        return nil;
    }
}
