//
//  FilterProtocol.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public protocol FilterProtocol {
    func prepareFilter(request:EverliveRequest) -> Void
}