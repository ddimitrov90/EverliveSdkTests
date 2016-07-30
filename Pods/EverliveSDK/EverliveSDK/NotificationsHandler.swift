//
//  NotificationsHandler.swift
//  EverliveSDK
//
//  Created by Dimitar Dimitrov on 7/26/16.
//  Copyright © 2016 Dimitar Dimitrov. All rights reserved.
//

import Foundation

public class NotificationsHandler : DataHandler<PushNotification> {
    override init(connection: EverliveConnection){
        super.init(connection: connection)
    }
}