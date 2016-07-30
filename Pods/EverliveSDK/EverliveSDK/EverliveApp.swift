//
//  EverliveApp.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

public class EverliveApp {
    var appId: String
    public private(set) var connection: EverliveConnection
    
    
    required public init(appId: String) {
        self.appId = appId
        self.connection = EverliveConnection(appId: self.appId, baseUrl: self._apiServerUrl, apiVersion: self._apiVersion)
        EVReflection.setBundleIdentifier(EverliveApp.self)
        ConversionOptions.DefaultNSCoding = [.PropertyMapping]
    }
    
    public func Data<T>() -> DataHandler<T>{
        return DataHandler<T>(connection: self.connection)
    }
    
    public func Users<T>() -> UsersHandler<T> {
        return UsersHandler(connection: self.connection)
    }
    
    public func Authentication() -> AuthenticationHandler {
        return AuthenticationHandler(connection: self.connection)
    }
    
    public func Files() -> FilesHandler {
        return FilesHandler(connection: self.connection)
    }
    
    public func Push() -> PushHandler {
        return PushHandler(connection: self.connection)
    }
    
    let _apiServerUrl: String = "http://api.everlive.com"
    let _apiVersion: String = "/v1"
}