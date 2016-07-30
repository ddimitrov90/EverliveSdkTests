//
//  BaseHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public class BaseHandler {
    var connection: EverliveConnection
    var typeName: String
    
    required public init(connection: EverliveConnection, typeName: String){
        self.connection = connection
        self.typeName = typeName
    }
    
    public func prepareUrl() -> String {
        return typeName
    }
}