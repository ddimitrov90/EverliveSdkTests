//
//  UpdateField.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public class UpdateField {
    public var FieldName: String
    public var Modifier: UpdateModifier
    public var Value: AnyObject
    
    public required init(fieldName: String, modifier: UpdateModifier, value: AnyObject){
        self.FieldName = fieldName
        self.Modifier = modifier
        self.Value = value
    }
    
}