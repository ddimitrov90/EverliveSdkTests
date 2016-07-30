//
//  UpdateObject.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol Updateable {

    var isObjectModified: Bool{
        get
    }
    
    func markObjectAsNotModified() -> Void
    
    func markObjectAsDirty() -> Void
    
    func markPropertyAsNotModified(propertyName:String) -> Void
    
    func getJsonUpdateObject(isMultiple: Bool) -> JSON
}