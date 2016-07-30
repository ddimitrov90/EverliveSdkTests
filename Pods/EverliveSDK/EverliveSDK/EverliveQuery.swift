//
//  EverliveQuery.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON


public class EverliveQuery: QueryProtocol {
    private var filter: [FilterCondition] = []
    private var compoundOperator: String = ""
    
    public init(){
        
    }
    
    public func filter(fieldName: String, equalTo: AnyObject) -> EverliveQuery {
        self.filter.append(ValueCondition(key: fieldName, value: equalTo, operand: "$eq"))
        return self
    }
    
    public func filter(fieldName: String, notEqualTo: AnyObject) -> EverliveQuery {
        self.filter.append(ValueCondition(key: fieldName, value: notEqualTo, operand: "$ne"))
        return self
    }
    
    public func filter(fieldName: String, greaterThan: Float, orEqual: Bool) -> EverliveQuery  {
        var op: String = "$gt"
        if orEqual {
            op = op + "e"
        }
        self.filter.append(ValueCondition(key: fieldName, value: greaterThan, operand: op))
        return self
    }
    
    public func filter(fieldName: String, lessThan: Float,  orEqual: Bool) -> EverliveQuery  {
        var op: String = "$lt"
        if orEqual {
            op = op + "e"
        }
        self.filter.append(ValueCondition(key: fieldName, value: lessThan, operand: op))
        return self
    }
    
    public func filter(fieldName: String, startsWith: String, caseSensitive:Bool) -> EverliveQuery {
        self.filter.append(RegexCondition(key: fieldName, value: startsWith, operand: "startsWith", caseSensitive: caseSensitive))
        return self
    }
    
    public func filter(fieldName: String, endsWith: String, caseSensitive:Bool) -> EverliveQuery {
        self.filter.append(RegexCondition(key: fieldName, value: endsWith, operand: "endsWith", caseSensitive: caseSensitive))
        return self
    }
    
    public func filter(fieldName: String, contains: String, caseSensitive:Bool) -> EverliveQuery {
        self.filter.append(RegexCondition(key: fieldName, value: contains, operand: "contains", caseSensitive: caseSensitive))
        return self
    }
    
    public func and() {
        self.compoundOperator = "$and"
    }
    
    public func or() {
        self.compoundOperator = "$or"
    }
    
    public func getJson() -> String {
        let jsonObj = self.getJsonObj()
        return jsonObj.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
    }
    
    public func getJsonObj() -> JSON {
        if self.compoundOperator != "" {
            var filterArray: [JSON] = []
            for index in 0...self.filter.count - 1{
                filterArray.append(self.filter[index].getJsonObj())
            }
            let filterArrayJson = JSON(filterArray)
            let resultFilter:JSON = JSON([self.compoundOperator: filterArrayJson])
            return resultFilter
        } else {
            return self.filter[0].getJsonObj()
        }
    }
}