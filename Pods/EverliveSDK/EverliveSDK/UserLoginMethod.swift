//
//  UserLoginMethod.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

public class UserLoginMethod : LoginMethod {
    public var Identifier: String
    public var Password: String
    
    required public init(identifier: String, password: String){
        self.Identifier = identifier
        self.Password = password
    }
    
    public func prepareLogin(request: EverliveRequest) {
        var payload:[String:String] = [:]
        payload["identifier"] = self.Identifier
        payload["password"] = self.Password
        payload["grant_type"] = "password"
        let jsonPayload:JSON = JSON(payload)
        let body: String = jsonPayload.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
        request.body = body.dataUsingEncoding(NSUTF8StringEncoding)        
    }
}