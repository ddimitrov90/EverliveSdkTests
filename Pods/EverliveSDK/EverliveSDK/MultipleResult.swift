//
//  MultipleResult.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/17/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

public class MultipleResult<T: EVObject> : ResultBase, EVGenericsKVC {
    
    var data: [T] = [T] ()
    var count: Int?
    
    required public init() {
        super.init()
    }
    
    public override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "Result":
            
            if value is NSArray {
                let result = value as! [NSDictionary]
                if result.count == 0 {
                    return
                }
                
                for index in 0...result.count-1 {
                    let tempResult = T()
                    EVReflection.setPropertiesfromDictionary(result[index], anyObject: tempResult)
                    data.append(tempResult)
                }
            } else if value is NSDictionary {
                let result = value as! NSDictionary
                for (_, val) in result {
                    let tempResult = T()
                    EVReflection.setPropertiesfromDictionary(val as! NSDictionary, anyObject: tempResult)
                    data.append(tempResult)
                }
            }
        case "Count":
            count = value as? Int
        default:
            print("---> setValue '\(value)' for key '\(key)' should be handled.")
        }
    }
    
}