//
//  UpdateByFilterHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

public class UpdateByFilterHandler : UpdateBaseHandler, FilterProtocol{
    var query: QueryProtocol
    
    required public init(query: QueryProtocol, updateObject: Updateable, connection: EverliveConnection, typeName: String){
        self.query = query
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
        let updateByFilterRequest = EverliveRequest(httpMethod: "PUT", url: url)
        self.prepareFilter(updateByFilterRequest)
        self.prepareUpdateObject(updateByFilterRequest)
        
        self.connection.executeRequest(updateByFilterRequest) { (response: Result<UpdateResult, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result, result.getErrorObject())
            }
        }
    }
    
    public func prepareFilter(request: EverliveRequest) {
        let filterString = self.query.getJson()
        request.applyFilter(filterString)
    }
}