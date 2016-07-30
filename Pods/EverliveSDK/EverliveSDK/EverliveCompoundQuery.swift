//
//  EverliveCompoundQuery.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

public class EverliveCompoundQuery:QueryProtocol {
    private var queries: [EverliveQuery] = []
    private var compoundOperator: String = ""
    
    public init(){
        
    }
    
    public func and(queries: [EverliveQuery]){
        self.queries = queries
        self.compoundOperator = "$and"
    }
    
    public func or(queries: [EverliveQuery]){
        self.queries = queries
        self.compoundOperator = "$or"
    }
    
    public func getJson() -> String {
        let jsonObj = self.getJsonObj()
        return jsonObj.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
    }
    
    public func getJsonObj() -> JSON {
        var filterArray: [JSON] = []
        for index in 0...self.queries.count - 1{
            filterArray.append(self.queries[index].getJsonObj())
        }
        let filterArrayJson = JSON(filterArray)
        let resultFilter:JSON = JSON([self.compoundOperator: filterArrayJson])
        return resultFilter
    }
}
