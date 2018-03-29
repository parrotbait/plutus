//
//  User+JSON.swift
//  plutus
//
//  Created by Eddie Long on 28/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import SWLogger

extension User {
    public static func fromJson(filename: String) -> User {
        let file = FileManager.caches(filename)
        let cachesFile = file.path
        if FileManager.default.fileExists(atPath: cachesFile) == false {
            return User(coins: [UserCoin](), currency: Config.defaultCurrency)
        }
        
        do {
            let data = try Data.init(contentsOf: file, options: Data.ReadingOptions.alwaysMapped)
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(User.self, from: data)
            } catch let jsonError {
                Log.e(jsonError.localizedDescription)
            }
        } catch let dataLoadError {
            Log.e(dataLoadError.localizedDescription)
        }
        return User(coins: [UserCoin](), currency: Config.defaultCurrency)
    }
    
    public static func toJson(filename: String, user: User) {
        let url = FileManager.caches(filename)

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let data = try! encoder.encode(user)
                let json = String(data: data, encoding: .utf8)!
                try json.data(using: String.Encoding.utf8)!.write(to: url, options: Data.WritingOptions.atomicWrite)
            } catch let jsonError {
                Log.e(jsonError.localizedDescription)
                try FileManager.default.removeItem(at: url)
            }
        } catch let dataLoadError {
            Log.e(dataLoadError.localizedDescription)
            do {
                try FileManager.default.removeItem(at: url)
            } catch let deleteError {
                Log.e(deleteError.localizedDescription)
            }
        }
    }
}
