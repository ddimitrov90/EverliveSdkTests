//
//  AccessToken.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

@objc(AccessToken)
public class AccessToken : DataItem {
    public var Token:String = ""
    public var TokenType: String = "bearer"
    public var ExpirationDate: NSDate?
    public var PrincipalId: String?
    
    public required init(){
        
    }
    
    public convenience init(token: String, tokenType: String){
        self.init()
        self.Token = token
        self.TokenType = tokenType
    }
    
    override public func propertyMapping() -> [(String?, String?)] {
        var parentMapping = super.propertyMapping()
        parentMapping.append(("Token", "access_token"))
        parentMapping.append(("TokenType", "token_type"))
        parentMapping.append(("ExpirationDate", "expiration_date"))
        parentMapping.append(("PrincipalId", "principal_id"))
        return parentMapping
    }
}