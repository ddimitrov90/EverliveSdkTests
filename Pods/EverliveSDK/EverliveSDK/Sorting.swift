//
//  Sorting.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum OrderDirection: Int {
    case Ascending = 1
    case Descending = -1
}

public class Sorting {
    var sortFields:[String:Int]
    //private var fieldsOrder: [String]
    
    public required init(fieldName: String, orderDirection: OrderDirection){
        self.sortFields = [:]
        //self.fieldsOrder = []
        self.addSortField(fieldName, orderDirection: orderDirection)
    }
    
    public func addSortField(fieldName:String, orderDirection: OrderDirection){
        self.sortFields[fieldName] = orderDirection.rawValue
        //self.fieldsOrder.append(fieldName)
    }
    
    public func getSortObject() -> String {
        if self.sortFields.count > 0 {
            let sortObject:JSON = JSON(self.sortFields)
            return sortObject.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
        }
        return ""
    }
}