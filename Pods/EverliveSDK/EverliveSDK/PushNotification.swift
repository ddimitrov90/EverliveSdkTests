//
//  PushNotification.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 7/26/16.
//  Copyright © 2016 Dimitar Dimitrov. All rights reserved.
//

import Foundation

public class PushNotification: DataItem {
    
    public var Message: String
    public var Filter: String?
    public var iOSNotification: NSDictionary?
    public var AndroidNotification: NSDictionary?
    
    public required init(message:String) {
        self.Message = message
    }
    
    public required init() {
        self.Message = ""
    }
    
    override public func propertyMapping() -> [(String?, String?)] {
        return [("iOSNotification","IOS"), ("AndroidNotification","Android")]
    }
    
    override public func getTypeName() -> String {
        return "Push/Notifications"
    }
}