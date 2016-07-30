//
//  UpdateByIdHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

public class UpdateByIdHandler : UpdateBaseHandler {
    var id: String
    
    required public init(id:String, updateObject: Updateable, connection: EverliveConnection, typeName: String){
        self.id = id
        super.init(updateObject: updateObject, connection: connection, typeName: typeName)
    }

    required public init(connection: EverliveConnection, typeName: String) {
        fatalError("init(connection:typeName:) has not been implemented")
    }

    required public init(updateObject: Updateable, connection: EverliveConnection, typeName: String) {
        fatalError("init(updateObject:connection:typeName:) has not been implemented")
    }
    
    public func execute(completionHandler: (UpdateResult, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let updateById = EverliveRequest(httpMethod: "PUT", url: url)
        self.prepareUpdateObject(updateById)
        
        self.connection.executeRequest(updateById) { (response: Result<UpdateResult, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result, result.getErrorObject())
            }
        }
    }
    
    public override func prepareUrl() -> String {
        let baseUrl = super.prepareUrl()
        return baseUrl + "/\(self.id)"
    }
}