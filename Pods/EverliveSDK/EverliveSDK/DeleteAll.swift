//
//  DeleteByIdHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/19/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection


public class DeleteAllHandler : BaseHandler{
    
    required public init(connection: EverliveConnection, typeName: String){
        super.init(connection: connection, typeName: typeName)
    }
    
    public func execute(completionHandler: (Int?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let deleteAllRequest = EverliveRequest(httpMethod: "DELETE", url: url)
        
        self.connection.executeRequest(deleteAllRequest) { (response: Result<DeleteResult, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result.deleteResult, result.getErrorObject())
            }
        }
    }
}