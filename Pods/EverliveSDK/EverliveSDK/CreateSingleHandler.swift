//
//  CreateSingleHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/17/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

public class CreateSingleHandler<T: DataItem> : BaseHandler{
    var item: T
    
    public init(newItem: T, connection: EverliveConnection, typeName: String){
        self.item = newItem
        super.init(connection: connection, typeName: typeName)
    }
    
    public func execute(completionHandler: (Bool, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let body: String = EVReflection.prepareCreateObjectString(self.item, performKeyCleanup: false)
        let data = body.dataUsingEncoding(NSUTF8StringEncoding)
        let createRequest = EverliveRequest(httpMethod: "POST", url: url, body: data!)
        
        self.connection.executeRequest(createRequest) { (response: Result<SingleResult<CreateBaseResult>, NSError>) -> Void in
            if let result = response.value {
                var success = false
                let errorObject = result.getErrorObject()
                if errorObject == nil {
                    self.item.Id = result.data!.Id
                    self.item.CreatedAt = result.data!.CreatedAt
                    success = true
                }
                completionHandler(success, result.getErrorObject())
            }
        }
    }
}