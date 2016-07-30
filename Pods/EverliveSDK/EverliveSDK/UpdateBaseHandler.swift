//
//  UpdateBaseHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public class UpdateBaseHandler : BaseHandler {
    var updateObject: Updateable
    
    required public init(updateObject: Updateable, connection: EverliveConnection, typeName: String){
        self.updateObject = updateObject
        super.init(connection: connection, typeName: typeName)
    }

    required public init(connection: EverliveConnection, typeName: String) {
        fatalError("init(connection:typeName:) has not been implemented")
    }
    
    public func prepareUpdateObject(request: EverliveRequest) -> Void {
        let updateObj = self.updateObject.getJsonUpdateObject(false)
        let body: String = updateObj.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
        let data = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.setBodyData(data!)
    }
}
