//
//  ResultBase.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

public class ResultBase :EVObject {
    var message: String?
    var errorCode: String?
    
    func getErrorObject() -> EverliveError? {
        if self.message != nil {
            return EverliveError(message: self.message, errorCode: self.errorCode)
        } else {
            return nil
        }
    }
}