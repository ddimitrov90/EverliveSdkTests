//
//  File.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 4/4/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public class File : DataItem {
    public var Filename: String?
    public var Uri: String?
    public var ContentType: String?
    public var Data: NSData?
    
    override public func propertyMapping() -> [(String?, String?)] {
        var parentMapping = super.propertyMapping()
        parentMapping.append(("Storage", nil))
        parentMapping.append(("Length", nil))
        return parentMapping
    }
    
    override public func getTypeName() -> String {
        return "Files"
    }
}