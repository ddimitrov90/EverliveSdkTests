//
//  EverliveError.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/17/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public class EverliveError {
    private var message:String?
    private var errorCode: String?
    
    public var Message:String? {
        get {
            return self.message
        }
        set {
            self.message = newValue
        }
    }
    
    public var ErrorCode: String? {
        get {
            return self.errorCode
        }
        set {
            self.errorCode = newValue
        }
    }
    
    init(){
        
    }
    
    init(message:String?, errorCode: String?){
        self.message = message
        self.errorCode = errorCode
    }
}