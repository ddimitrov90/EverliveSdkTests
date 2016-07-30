//
//  User.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/9/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation


public class User : DataItem {
    public var Username: String? {
        didSet {
            propertyChanged.raise("Username")
        }
    }
    
    public var Password: String? {
        didSet {
            propertyChanged.raise("Password")
        }
    }
    
    public var DisplayName: String? {
        didSet {
            propertyChanged.raise("DisplayName")
        }
    }
    
    public var Email: String? {
        didSet {
            propertyChanged.raise("Email")
        }
    }
    
    public var RoleId: String? {
        didSet {
            propertyChanged.raise("RoleId")
        }
    }
    
    public var IsVerified: Bool = false {
        didSet {
            propertyChanged.raise("IsVerified")
        }
    }
    
    public var SecretQuestionId: String? {
        didSet {
            propertyChanged.raise("SecretQuestionId")
        }
    }
    
    public var SecretAnswer: String? {
        didSet {
            propertyChanged.raise("SecretAnswer")
        }
    }
    
    override public func propertyMapping() -> [(String?, String?)] {
        var parentMapping = super.propertyMapping()
        parentMapping.append(("IsVerified", nil))
        parentMapping.append(("RoleId", "Role"))
        parentMapping.append(("IdentityProvider", nil))
        return parentMapping
    }
    
    override public func getTypeName() -> String {
        return "Users"
    }
}