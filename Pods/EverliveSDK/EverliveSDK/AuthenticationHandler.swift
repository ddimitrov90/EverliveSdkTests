//
//  AuthenticationHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public class AuthenticationHandler {
    
    var connection: EverliveConnection
    
    init(connection: EverliveConnection){
        self.connection = connection
    }
    
    public func login(username:String, password: String) -> LoginHandler{
        let userLoginMethod = UserLoginMethod(identifier: username, password: password)
        return LoginHandler(connection: self.connection, loginMethod: userLoginMethod)
    }
    
    public func login(masterKey:String) -> LoginHandler {
        let masterKeyLoginMethod = MasterKeyLoginMethod(masterKey: masterKey)
        return LoginHandler(connection: self.connection, loginMethod: masterKeyLoginMethod)
    }
    
    public func logout() -> LogoutHandler {
        return LogoutHandler(connection: self.connection)
    }
}