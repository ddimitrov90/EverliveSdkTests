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


public class DeleteByIdHandler : BaseHandler {
    var id: String
    
    required public init(id: String, connection: EverliveConnection, typeName: String){
        self.id = id
        super.init(connection: connection, typeName: typeName)
    }

    required public init(connection: EverliveConnection, typeName: String) {
        fatalError("init(connection:typeName:) has not been implemented")
    }
    
    public func execute(completionHandler: (Int?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let deleteByIdRequest = EverliveRequest(httpMethod: "DELETE", url: url)
        
        self.connection.executeRequest(deleteByIdRequest) { (response: Result<DeleteResult, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result.deleteResult, result.getErrorObject())
            }
        }
    }
    
    public override func prepareUrl() -> String {
        let baseUrl = super.prepareUrl()
        return baseUrl + "/\(self.id)"
    }
}