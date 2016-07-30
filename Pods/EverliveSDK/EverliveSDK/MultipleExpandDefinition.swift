//
//  MultipleExpandDefinition.swift
//  Pods
//
//  Created by Dimitar Dimitrov on 4/24/16.
//
//

import Foundation
import SwiftyJSON
import EVReflection

public class MultipleExpandDefinition: QueryProtocol {
    var expandDefinitions: [ExpandDefinition]
    
    required public init(expandDefinitions: [ExpandDefinition]){
        self.expandDefinitions = expandDefinitions
    }
    
    public func getJson() -> String {
        let jsonObj = self.getJsonObj()
        let result = jsonObj.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
        return result
        /*
        var test2:[String:AnyObject] = [:]
        var test3:[String:AnyObject] = [:]
        test3["ReturnAs"] = "UserProfile"
        test3["Expand"] = ["Picture": ["ReturnAs":"ProfilePicture"]]
        test2["UserId"] = test3
        
        var asd = JSON(test2)
        var result3 = asd.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
        */
    }
    
    public func getJsonObj() -> JSON {
        var exp:[String:AnyObject] = [:]
        for index in 0...self.expandDefinitions.count-1 {
            exp[self.expandDefinitions[index].relationField] = self.expandDefinitions[index].prepareDefinitionObject()
        }
        let expandHeader = JSON(exp)
        
        return expandHeader
    }
}