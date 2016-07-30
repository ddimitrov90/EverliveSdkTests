//
//  FilterCondition.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

class FilterCondition {
    var key: String
    var operand: String
    
    init(key: String, operand:String){
        self.key = key
        self.operand = operand
    }
    
    func getJson() -> String {
        return "{ }"
    }
    
    func getJsonObj() -> JSON {
        return []
    }
}