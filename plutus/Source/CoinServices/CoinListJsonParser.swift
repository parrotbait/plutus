//
//  CoinListJsonParser.swift
//  plutus
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import SWLogger

struct CoinListJsonParser : JsonParser {
    typealias ReturnType = [Coin]!
    public func parse(_ jsonData : NSData) -> ReturnType {
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary {
                var coinList = [Coin]()
                if let coinData : NSDictionary = jsonResult["Data"] as? NSDictionary {
                    
                    for coin in coinData {
                        if let coinValues : NSDictionary = coin.value as? NSDictionary {
                            let sortOrderObj = coinValues["SortOrder"]
                            var sortOrder = Int.max
                            if let sort = sortOrderObj as? String {
                                if let sortInt = Int(sort) {
                                    sortOrder = sortInt
                                }                                
                            }
                            else if let sortInt = sortOrderObj as? Int {
                                sortOrder = sortInt
                            }
                            
                            var coinName = (coinValues["CoinName"] as! String)
                            coinName.trimWhitespace()
                            var coinFullname = coinValues["FullName"] as! String
                            coinFullname.trimWhitespace()
                            
                            let theCoin = Coin.init(coinKey: coin.key as! String, name: coinName, fullname: coinFullname, id: coinValues["Id"] as! String, imageUrl: coinValues["ImageUrl"] as? String ?? "",
                                sort: sortOrder,
                                descriptionUrl: coinValues["Url"] as? String ?? "")
                            
                            coinList.append(theCoin)
                        }
                    }
                    coinList.sort()
                }
                return coinList
            }
        } catch {
            Log.e("Error!! Unable to parse json")
        }
        return nil;
    }
}
