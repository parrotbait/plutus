//
//  FileManager+Paths.swift
//  plutus
//
//  Created by Eddie Long on 28/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

extension FileManager {
    public static func documents(_ path: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentDirectory!.appendingPathComponent(path)
    }
    
    public static func caches(_ path: String) -> URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        return cachesDirectory!.appendingPathComponent(path)
    }
}
