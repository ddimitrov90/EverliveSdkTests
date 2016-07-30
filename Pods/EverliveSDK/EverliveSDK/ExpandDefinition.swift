//
//  ExpandDefinition.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/26/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON
import EVReflection

public class ExpandDefinition : QueryProtocol {
    var relationField: String
    var ReturnAs: String
    public var TargetTypeName: String?
    
    public var ChildExpand: ExpandDefinition?
    public var Sort: Sorting?
    //public var Filter: QueryProtocol?
    
    convenience public init(relationField: String){
        self.init(relationField: relationField, returnAs: relationField)
    }
    
    required public init(relationField: String, returnAs: String){
        self.relationField = relationField
        self.ReturnAs = returnAs
    }
    
    public func getJson() -> String {
        let jsonObj = self.getJsonObj()
        return jsonObj.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
    }
    
    public func getJsonObj() -> JSON {
        let expandHeader = [self.relationField : self.prepareDefinitionObject()]
        return JSON(expandHeader)
    }
    
    internal func prepareDefinitionObject() -> [String: AnyObject] {
        var expandDefinitionObject:[String:AnyObject] = [:]
        expandDefinitionObject["ReturnAs"] = self.ReturnAs
        expandDefinitionObject["TargetTypeName"] = self.TargetTypeName
        
        if let childExpand = self.ChildExpand {
            expandDefinitionObject["Expand"] = [ childExpand.relationField : childExpand.prepareDefinitionObject()]
        }
        
        if let sort = self.Sort {
            expandDefinitionObject["Sort"] = sort.sortFields
        }
        
        //if let filter = self.Filter {
        //     expandDefinitionObject["Filter"] = filter.getJson()
        //}
        
        return expandDefinitionObject
    }
    
}