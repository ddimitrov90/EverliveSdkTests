//
//  SingleResult.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

public class SingleResult<T: EVObject> : ResultBase, EVGenericsKVC {
    
    var data: T?
    
    required public init() {
        super.init()
    }
    
    public override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "Result":
            data = T()
            EVReflection.setPropertiesfromDictionary(value as! NSDictionary, anyObject: data!)
        default:
            print("---> setValue '\(value)' for key '\(key)' should be handled.")
        }
    }

}