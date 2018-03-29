//
//  Database.swift
//  plutus
//
//  Created by Eddie Long on 24/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation


protocol Database {
    associatedtype itemType
    typealias DatabaseResult = Result<[itemType], DatabaseError>

    func save(itemList : [itemType])
    typealias DatabaseCallback = ((DatabaseResult) -> Void)
    func load(callback : @escaping DatabaseCallback)
}
