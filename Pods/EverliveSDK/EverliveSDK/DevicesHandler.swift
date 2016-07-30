//
//  DevicesHandler.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 7/23/16.
//  Copyright © 2016 Dimitar Dimitrov. All rights reserved.
//

import Foundation

public class DevicesHandler : DataHandler<PushDevice> {
    override init(connection: EverliveConnection){
        super.init(connection: connection)
    }
}