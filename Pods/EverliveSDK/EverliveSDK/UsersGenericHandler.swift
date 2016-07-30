//
//  GenericRequestHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/23/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public class UsersGenericHandler : BaseHandler {
    var method:String
    var body:JSON?
    
    public init(method:String, urlPath:String, connection:EverliveConnection){
        self.method = method
        super.init(connection: connection, typeName: urlPath)
    }
    
    public init(method:String, urlPath:String, body:JSON?, connection: EverliveConnection){
        self.method = method
        self.body = body
        super.init(connection: connection, typeName: urlPath)
    }

    required public init(connection: EverliveConnection, typeName: String) {
        fatalError("init(connection:typeName:) has not been implemented")
    }
    
    public func execute(completionHandler: (Bool, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let genericRequest = EverliveRequest(httpMethod: self.method, url: url)
        if let bodyData = self.body {
            let body: String = bodyData.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0))!
            let data = body.dataUsingEncoding(NSUTF8StringEncoding)
            genericRequest.setBodyData(data!)
            genericRequest.setValue("application/json", forHeader: "Content-Type")
        }
        
        self.connection.executeRequest(genericRequest) { (response: Result<GenericResult<Int>, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result.isTrue, result.getErrorObject())
            }
        }
    }
    
    override public func prepareUrl() -> String {
        return self.typeName
    }
}