//
//  UpdateObject.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

public class UpdateObject:Updateable {
    
    private var updatedFields:[UpdateField] = []
    
    public var UpdatedFields:[UpdateField] {
        get {
            return self.updatedFields
        }
        set {
            self.updatedFields = newValue
        }
    }
    
    public init(updateFields:[UpdateField]) {
        self.updatedFields = updateFields
    }
    
    
    public func getJsonUpdateObject(isMultiple: Bool) -> JSON {
        
        var resultUpdateObject: [String : [ String: AnyObject]] = [:]
        for index in 0...self.updatedFields.count - 1 {
           let modifier = self.getPropertyForModified(self.updatedFields[index].Modifier)
            if (resultUpdateObject[modifier] == nil){
                resultUpdateObject[modifier] = [:]
            }
            resultUpdateObject[modifier]![self.updatedFields[index].FieldName] = self.updatedFields[index].Value
        }
        return JSON(resultUpdateObject)
    }
    
    public func getPropertyForModified(modifier:UpdateModifier) -> String {
        switch modifier {
        case .Set:
            return "$set"
        case .Unset:
            return "$unset"
        case .Increment:
            return "$inc"
        }
    }
    
    public var isObjectModified: Bool{
        get {
            return false
        }
    }
    
    public func markObjectAsNotModified() -> Void {
        
    }
    
    public func markObjectAsDirty() -> Void {
        
    }
    
    public func markPropertyAsNotModified(propertyName:String) -> Void {
        
    }
}