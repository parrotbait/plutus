//
//  SSHttp.swift (super-simple http client)
//  plutus
//
//  Created by Eddie Long on 23/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

struct SSHttpClient {
    
    public let useRandomDelay = false
    
    typealias CompletionHandler = (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void
    
    func start(url: URL, _ handler : @escaping CompletionHandler) {
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if self.useRandomDelay {
                let randLower : UInt32 = 1
                let randUpper : UInt32 = 50
                let randDelayTime = arc4random_uniform(randUpper - randLower) + randLower
                let randDelayTimer = Double(randDelayTime) / 10
                Thread.sleep(forTimeInterval: randDelayTimer)
            }
            
            handler(data, response, error)
        })
        task.resume()
    }
}
