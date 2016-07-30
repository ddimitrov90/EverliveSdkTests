//
//  CurrentDevice.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 7/23/16.
//  Copyright © 2016 Dimitar Dimitrov. All rights reserved.
//

import Foundation

public class CurrentDevice {
    var everliveConnection:EverliveConnection
    var pushHandler: PushHandler
    private static var currentDevice:CurrentDevice?
    public static func getInstance(connection: EverliveConnection, pushHandler: PushHandler) -> CurrentDevice {
        if CurrentDevice.currentDevice == nil {
            CurrentDevice.currentDevice = CurrentDevice(connection: connection, pushHandler: pushHandler)
        }
        return CurrentDevice.currentDevice!
    }
    
    private init(connection: EverliveConnection, pushHandler: PushHandler){
        self.everliveConnection = connection
        self.pushHandler = pushHandler
    }
    
    public func register(token: NSData, deviceParams: Dictionary<String,NSObject>?, completionHandler: (Bool, EverliveError?) -> Void) {
        let newDevice = PushDevice()
        newDevice.HardwareId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        var token = token.description.stringByReplacingOccurrencesOfString("<", withString: "")
        token = token.stringByReplacingOccurrencesOfString(">", withString: "")
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        newDevice.PushToken = token
        newDevice.PlatformType = 4
        newDevice.PlatformVersion = UIDevice.currentDevice().systemVersion
        newDevice.Locale = NSLocale.currentLocale().localeIdentifier
        newDevice.TimeZone = NSTimeZone.defaultTimeZone().name
        newDevice.Parameters = deviceParams
        
        self.pushHandler.Devices().create(newDevice).execute(completionHandler)
    }
    
    public func updateRegistration(deviceParams: Dictionary<String,NSObject>, completionHandler: (UpdateResult, EverliveError?) -> Void){
        self.getRegistration { (device:PushDevice?, err: EverliveError?) in
            if let registration = device {
                registration.Parameters = deviceParams
                self.pushHandler.Devices().updateById("HardwareId/" + registration.HardwareId!, updateObject: registration).execute(completionHandler)
            } else {
                completionHandler(UpdateResult(), err)
            }
        }
    }
    
    public func getRegistration(completionHandler: (PushDevice?, EverliveError?) -> Void){
        let hardwareId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.pushHandler.Devices().getById("HardwareId/" + hardwareId!).execute(completionHandler)
    }
    
    public func unregister(completionHandler: (Bool, EverliveError?) -> Void){
        let hardwareId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.pushHandler.Devices().deleteById("HardwareId/" + hardwareId!).execute { (resultCount:Int?, err:EverliveError?) in
            completionHandler(resultCount != nil && resultCount > 0, err)
        }
    }
    
}