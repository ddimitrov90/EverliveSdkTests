//
//  GetByFilterHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection


public class GetCountHandler : BaseHandler, FilterProtocol {
    var filter: QueryProtocol?
    
    required public init(filter: QueryProtocol, connection: EverliveConnection, typeName: String){
        self.filter = filter
        super.init(connection: connection, typeName: typeName)
    }

    required public init(connection: EverliveConnection, typeName: String) {
        super.init(connection: connection, typeName: typeName)
    }
    
    public func execute(completionHandler: (Int?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let getByFilterRequest = EverliveRequest(httpMethod: "GET", url: url)
        self.prepareFilter(getByFilterRequest)
        
        self.connection.executeRequest(getByFilterRequest) { (response: Result<GenericResult<Int>, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result.Result, result.getErrorObject())
            }
        }
    }
    
    public func prepareFilter(request:EverliveRequest) -> Void {
        if(self.filter != nil){
            let filterString = self.filter!.getJson()
            request.applyFilter(filterString)
        }
    }
    
    public override func prepareUrl() -> String {
        let url = super.prepareUrl()
        return url + "/_count"
    }
}