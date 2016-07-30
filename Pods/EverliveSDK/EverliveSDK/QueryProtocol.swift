//
//  QueryProtocol.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol QueryProtocol {
    func getJson() -> String
    
    func getJsonObj() -> JSON
}