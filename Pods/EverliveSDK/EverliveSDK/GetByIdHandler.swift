//
//  GetByIdHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

public class GetByIdHandler<T: DataItem> : BaseHandler{
    var id: String
    var expand:QueryProtocol?
    
    required public init(id:String, connection: EverliveConnection, typeName: String){
        self.id = id
        super.init(connection: connection, typeName: typeName)
    }
    
    public func execute(completionHandler: (T?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let getByIdRequest = EverliveRequest(httpMethod: "GET", url: url)
        getByIdRequest.applyExpand(self.expand)
        
        self.connection.executeRequest(getByIdRequest) { (response: Result<SingleResult<T>, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result.data, result.getErrorObject())
            }
        }
    }
    
    public func expand(expandObj: ExpandDefinition) -> GetByIdHandler {
        self.expand = expandObj
        return self
    }
    
    public func expand(multipleExpand: MultipleExpandDefinition) -> GetByIdHandler {
        self.expand = multipleExpand
        return self
    }
    
    public override func prepareUrl() -> String {
        let url = super.prepareUrl()
        return url + "/\(self.id)"
    }
}