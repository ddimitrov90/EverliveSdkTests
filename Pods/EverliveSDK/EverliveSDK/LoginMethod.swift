//
//  LoginMethod.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public protocol LoginMethod {
    func prepareLogin(request: EverliveRequest) -> Void
}