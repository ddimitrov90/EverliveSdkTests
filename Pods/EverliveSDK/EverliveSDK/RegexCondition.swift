//
//  ValueCondition.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

class RegexCondition : FilterCondition {
    var value: String
    var isCaseSensitive: Bool
    
    init(key: String, value:  String, operand:String, caseSensitive:  Bool){
        self.value = value
        self.isCaseSensitive = caseSensitive
        super.init(key: key, operand: operand)
    }
    
    override func getJson() -> String {
        let regexOperand = self.operandDefinitions[operand]
        let regexValue = regexOperand!.stringByReplacingOccurrencesOfString("%value%", withString: self.value)
        var innerFilter = [ "$regex" : regexValue]
        if(!self.isCaseSensitive){
            innerFilter["$options"] = "i"
        }
        let fieldNameFilter = [ self.key: innerFilter]
        let resultJsonFilter:JSON = JSON(fieldNameFilter)
        return resultJsonFilter.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
    }
    
    override func getJsonObj() -> JSON {
        let regexOperand = self.operandDefinitions[operand]
        let regexValue = regexOperand!.stringByReplacingOccurrencesOfString("%value%", withString: self.value)
        var innerFilter = [ "$regex" : regexValue]
        if(!self.isCaseSensitive){
            innerFilter["$options"] = "i"
        }
        let fieldNameFilter = [ self.key: innerFilter]
        let resultJsonFilter:JSON = JSON(fieldNameFilter)
        return resultJsonFilter
    }
    
    let operandDefinitions: [String: String] = ["contains" : "%value%", "startsWith": "^%value%", "endsWith": "%value%$"]
}