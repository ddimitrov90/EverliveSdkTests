//
//  MasterKeyLoginMethod.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

import SwiftyJSON

public class MasterKeyLoginMethod : LoginMethod {
    public var masterKey: String
    
    required public init(masterKey: String){
        self.masterKey = masterKey
    }
    
    public func prepareLogin(request: EverliveRequest) {
        var payload:[String:String] = [:]
        payload["masterkey"] = self.masterKey
        payload["grant_type"] = "masterkey"
        let jsonPayload:JSON = JSON(payload)
        let body: String = jsonPayload.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
        request.body = body.dataUsingEncoding(NSUTF8StringEncoding)
    }
}