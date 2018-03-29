//
//  Coin.swift
//  plutus
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import CoreLocation

struct Coin : Codable {
    var coinKey : String; // Coin key
    var name : String; // Coin name
    var fullname : String; // Coin full name
    var id : String; // coin id
    var imageUrl : String; // Image URL
    var sort : Int; // sort order
    var descriptionUrl : String; // A link to the coin description
}
