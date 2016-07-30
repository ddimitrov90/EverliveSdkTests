//
//  ValueCondition.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ValueCondition : FilterCondition {
    var value: AnyObject
    
    init(key: String, value:  AnyObject, operand:String){
        self.value = value
        super.init(key: key, operand: operand)
    }    
    
    override func getJson() -> String {
        let innerFilter = [ self.operand: self.value]
        let fieldNameFilter = [ self.key: innerFilter]
        let resultJsonFilter:JSON = JSON(fieldNameFilter)
        return resultJsonFilter.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
    }
    
    override func getJsonObj() -> JSON {
        let innerFilter = [ self.operand: self.value]
        let fieldNameFilter = [ self.key: innerFilter]
        let resultJsonFilter:JSON = JSON(fieldNameFilter)
        return resultJsonFilter
    }
    
    //let operandDefinitions: [String: String] = ["eq" : ""]
}