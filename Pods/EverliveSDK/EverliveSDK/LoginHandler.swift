//
//  LoginHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire

public class LoginHandler {
    var loginMethod: LoginMethod
    var connection: EverliveConnection
    
    required public init(connection: EverliveConnection, loginMethod: LoginMethod){
        self.connection = connection
        self.loginMethod = loginMethod
    }
    
    public func execute(completionHandler: (AccessToken?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let loginRequest = EverliveRequest(httpMethod: "POST", url: url)
        self.preparePayload(loginRequest)
        self.connection.executeRequest(loginRequest) { (response: Result<SingleResult<AccessToken>, NSError>) -> Void in
            if let result = response.value {
                if let token = result.data {
                    self.connection.saveAccessToken(token)
                }
                completionHandler(result.data, result.getErrorObject())
            }
        }
    }
    
    private func prepareUrl() -> String {
        //TODO: check login method type
        return "oauth/token"
    }
    
    private func preparePayload(request: EverliveRequest) {
        self.loginMethod.prepareLogin(request)
    }
}
