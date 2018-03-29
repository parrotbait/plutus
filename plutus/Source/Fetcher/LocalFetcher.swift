//
//  LocalFetcher.swift
//  plutus
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct LocalFetcher<Type, Parser : JsonParser> : FetcherProtocol {
    
    typealias ReturnType = Type
    typealias ErrorType = LoadError
    let parser : Parser
    let jsonName : String
    
    public func fetch(url: URL, completion: @escaping FetchCallback) {
        if let path = Bundle.main.url(forResource: jsonName, withExtension: "json") {
            if let jsonData = NSData(contentsOf: path) {
                if let result : Type = parser.parse(jsonData as NSData) as! Type {
                    completion(Result.success(result));
                } else {
                    completion(Result.failure(LoadError.parseError));
                }
            }
        }
        completion(Result.failure(LoadError.backendError));
    }
}
