//
//  GeoPoint.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 7/3/16.
//  Copyright © 2016 Dimitar Dimitrov. All rights reserved.
//

import Foundation
import EVReflection


public class GeoPoint : EVObject {
    public var Latitude:Double = 0.0
    public var Longitude:Double = 0.0
    
    override public func propertyMapping() -> [(String?, String?)] {
        return [("Latitude","latitude"), ("Longitude", "longitude")]
    }
}