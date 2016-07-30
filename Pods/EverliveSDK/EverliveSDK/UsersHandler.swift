//
//  UsersHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import SwiftyJSON

public class UsersHandler<T:User> : DataHandler<T> {
    override init(connection: EverliveConnection){
        super.init(connection: connection)
    }
    
    public func getMe() -> GetByIdHandler<User> {
        return GetByIdHandler(id: "me", connection: self.connection, typeName: self.typeName)
    }
    
    /*public func verifyUser(verificationCode: String) -> UsersGenericHandler {
        return UsersGenericHandler(method: "GET", urlPath: "Users/verify", connection: self.connection)
    }*/
    
    public func resendVerificiationEmail(username: String) -> UsersGenericHandler {
        let jsonBody = JSON(["Username":username])
        return UsersGenericHandler(method: "POST", urlPath: "Users/verify/resend", body: jsonBody, connection: self.connection)
    }
    
    public func resendVerificationEmail(userId: String) -> UsersGenericHandler {
        let jsonBody = JSON(["UserId":userId])
        return UsersGenericHandler(method: "POST", urlPath: "Users/verify/resend", body: jsonBody, connection: self.connection)
    }
    
    public func resetPasswordForUsername(username: String) -> UsersGenericHandler {
        let jsonBody = JSON(["Username":username])
        return UsersGenericHandler(method: "POST", urlPath: "Users/resetpassword", body: jsonBody, connection: self.connection)
    }
    
    public func resetPasswordForEmail(email: String) -> UsersGenericHandler {
        let jsonBody = JSON(["Email":email])
        return UsersGenericHandler(method: "POST", urlPath: "Users/resetpassword", body: jsonBody, connection: self.connection)
    }
    
    public func setNewPassword(identifier:String, secretQuestionId: String, secretAnswer: String, newPassword: String) -> UsersGenericHandler{
        let bodyDict = [
            "Identifier":identifier,
            "SecretQuestionId": secretQuestionId,
            "SecretAnswer": secretAnswer,
            "NewPassword": newPassword
        ]
        let jsonBody = JSON(bodyDict)
        return UsersGenericHandler(method: "POST", urlPath: "Users/setpassword", body: jsonBody, connection: self.connection)
    }
    
    public func setNewPassword(passwordResetCode: String, newPassword: String) -> UsersGenericHandler{
        let bodyDict = [
            "ResetCode":passwordResetCode,
            "NewPassword": newPassword
        ]
        let jsonBody = JSON(bodyDict)
        return UsersGenericHandler(method: "POST", urlPath: "Users/setpassword", body: jsonBody, connection: self.connection)
    }
}
