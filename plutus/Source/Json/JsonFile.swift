//
//  JsonFile.swift
//  plutus
//
//  Created by Eddie Long on 28/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import SWLogger
typealias Json = Dictionary<String, AnyObject>

struct JsonFile {
    public func loadJson(path : String) -> Json? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Json {
                return jsonResult
            }
        } catch(let error) {
            Log.e(error.localizedDescription)
        }
        return nil
    }
}
