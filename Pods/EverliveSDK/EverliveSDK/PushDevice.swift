//
//  PushDevice.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 7/23/16.
//  Copyright © 2016 Dimitar Dimitrov. All rights reserved.
//

import Foundation

public class PushDevice : DataItem {
    
    public var HardwareId: String? {
        didSet {
            propertyChanged.raise("HardwareId")
        }
    }
    
    public var PushToken: String? {
        didSet {
            propertyChanged.raise("PushToken")
        }
    }
    
    public var PlatformType: Int? {
        didSet {
            propertyChanged.raise("PlatformType")
        }
    }
    
    public var PlatformVersion: String? {
        didSet {
            propertyChanged.raise("PlatformVersion")
        }
    }
    
    public var Locale: String? {
        didSet {
            propertyChanged.raise("Locale")
        }
    }
    
    public var TimeZone: String? {
        didSet {
            propertyChanged.raise("TimeZone")
        }
    }
    
    public var Parameters: NSDictionary? {
        didSet {
            propertyChanged.raise("Parameters")
        }
    }
    
    override public func getTypeName() -> String {
        return "Push/Devices"
    }
}