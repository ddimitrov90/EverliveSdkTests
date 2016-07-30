//
//  SingleResult.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

public class GenericResult<T> : ResultBase {
    
    var Result: T?
    var isTrue: Bool = false
    
    required public init() {
        super.init()
    }
    
    override public func propertyConverters() -> [(String?, ((Any?) -> ())?, (() -> Any?)?)] {
        return [
            (
                "Result",
                {
                    self.isTrue = ($0 as? Int == 1) // for generic handlers that return Bool, JSON from Data turns true to 1
                    self.Result = $0 as? T
                }
                , { return self.Result})
        ]
    }
}