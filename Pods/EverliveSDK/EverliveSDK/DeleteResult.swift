//
//  DeleteResult.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/19/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

public class DeleteResult : ResultBase, EVGenericsKVC {
    
    var deleteResult: Int?
    
    required public init() {
        super.init()
    }
    
    public override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "Result":
            deleteResult = value as? Int
        default:
            print("---> setValue '\(value)' for key '\(key)' should be handled.")
        }
    }
    
}