//
//  PushHandler.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 7/23/16.
//  Copyright © 2016 Dimitar Dimitrov. All rights reserved.
//

import Foundation


public class PushHandler {
    var connection: EverliveConnection
    public var currentDevice: CurrentDevice {
        get {
            return CurrentDevice.getInstance(self.connection, pushHandler: self)
        }
    }
    
    init(connection: EverliveConnection){
        self.connection = connection
    }
    
    public func Devices() -> DevicesHandler {
        return DevicesHandler(connection: self.connection)
    }
    
    public func Notifications() -> NotificationsHandler {
        return NotificationsHandler(connection: self.connection)
    }
}