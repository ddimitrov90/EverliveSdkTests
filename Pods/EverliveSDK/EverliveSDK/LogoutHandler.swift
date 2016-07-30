//
//  LoginHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire

public class LogoutHandler {
    var connection: EverliveConnection
    
    required public init(connection: EverliveConnection){
        self.connection = connection
    }
    
    public func execute(completionHandler: (Bool, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let loginRequest = EverliveRequest(httpMethod: "GET", url: url)
        self.connection.executeRequest(loginRequest) { (response: Result<SingleResult<DataItem>, NSError>) -> Void in
            if let result = response.value {
                if result.data == nil {
                    self.connection.clearAccessToken()
                }
                completionHandler(true, result.getErrorObject())
            }
        }
    }
    
    private func prepareUrl() -> String {
        return "/oauth/logout"
    }
}
