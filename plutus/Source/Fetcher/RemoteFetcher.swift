//
//  RemoteFetcher.swift
//  plutus
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import SWLogger

struct RemoteFetcher<Type, Parser : JsonParser> : FetcherProtocol {
    
    typealias ReturnType = Type
    
    // Unfortunately due to limitations of Swift, this cannot be made generic
    typealias ErrorType = LoadError
    
    let httpClient = SSHttpClient()
    let parser : Parser
    
    public init(parserIn: Parser) {
        self.parser = parserIn
    }
    
    public func fetch(url: URL, completion: @escaping FetchCallback){
        // make the request
        httpClient.start(url: url) { (data, response, error) in
            if (error != nil) {
                completion(Result.failure(LoadError.backendError));
            } else {
                if let result : Type = self.parser.parse(data! as NSData) as? Type {
                    completion(Result.success(result));
                } else {
                    completion(Result.failure(LoadError.parseError));
                }
            }
        }
    }
}
