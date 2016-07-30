//
//  DataItem.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection
import SwiftyJSON

public class DataItem: EVObject, PropertyObservable, Updateable {
    public var Id: String? {
        didSet {
            propertyChanged.raise("Id")
        }
    }
    public var CreatedAt:String?{
        didSet {
            propertyChanged.raise("CreatedAt")
        }
    }
    public var ModifiedAt: NSDate?{
        didSet {
            propertyChanged.raise("ModifiedAt")
        }
    }
    public var CreatedBy: String?{
        didSet {
            propertyChanged.raise("CreatedBy")
        }
    }
    public var ModifiedBy: String?{
        didSet {
            propertyChanged.raise("ModifiedBy")
        }
    }
    
    public var Owner: String = ""
    public var Meta: DataItemMetadata?
    
    public func getTypeName() -> String {
        return ""
    }
    
    public required init(){
        super.init()
        self.propertyChanged.addHandler(self, handler: DataItem.onPropertyChanged)
        self.markObjectAsNotModified()
    }
    
    public let propertyChanged = Event<String>()
    
    func onPropertyChanged(propertyName: String) {
        self.changedProperties.insert(propertyName)
    }
    
    override public func propertyMapping() -> [(String?, String?)] {
        return [("propertyChanged",nil), ("changedProperties", nil), ("isDirty",nil), ("customProperties",nil)]
    }
    
    public func getSkippedProperties() -> Set<String> {
        return Set()
    }
    
    var changedProperties: Set<String> = Set<String>()
    var isDirty: Bool = false
    
    override public func setValue(value: AnyObject!, forUndefinedKey key: String) {
        self.customProperties[key] = value
    }
    
    private var customProperties: [String: AnyObject!] = [:]
    
    public func setValue(propertyName: String, value: AnyObject!){
        self.customProperties[propertyName] = value
    }
    
    public func getValue<T>(propertyName:String, defaultValue: T) -> T {
        if let value = self.customProperties[propertyName] {
            return value as! T
        } else {
            return defaultValue
        }
    }
    
    public func getJsonUpdateObject(isMultiple: Bool) -> JSON {
        let updateObject = EVReflection.prepareUpdateObjectString(self,changedProperties: self.changedProperties, performKeyCleanup: false)
        return JSON(updateObject)
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
            return self.changedProperties.count > 0
        }
    }
    
    public func markObjectAsNotModified() -> Void {
        self.changedProperties.removeAll()
        self.isDirty = false
    }
    
    public func markObjectAsDirty() -> Void {
        self.isDirty = true
    }
    
    public func markPropertyAsNotModified(propertyName:String) -> Void {
        self.changedProperties.remove(propertyName)
    }
}