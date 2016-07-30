//
//  EverliveConnection.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

public class EverliveConnection {
    var appId: String
    var baseUrl: String
    var apiVersion: String
    var accessToken: AccessToken?
    private var tokenKey: String
    
    init(appId: String, baseUrl: String, apiVersion: String){
        self.appId = appId
        self.baseUrl = baseUrl
        self.apiVersion = apiVersion
        self.tokenKey = "\(self.appId):everlive_access_token"
    }
    
    public func executeRequest(request:EverliveRequest, completionHandler: Response<AnyObject, NSError> -> Void) -> Void {
        let customRequest = self.prepareRequest(request)
        Alamofire.request(customRequest).responseJSON { response in
            completionHandler(response)
        }
    }
    
    func executeRequest<T : ResultBase> (request: EverliveRequest, completionHandler: (Result<T, NSError>) -> Void) -> Void {
        let req = self.prepareRequest(request)
        Alamofire.request(req).responseObject(completionHandler)
    }
    
    func uploadFile(file:File, completionHandler: (Result<MultipleResult<UploadFileResult>, NSError>) -> Void) {
        let uploadFileUrl = self.prepareUrl("Files")
        var headers: [String:String] = [:]
        if self.accessToken == nil {
            self.getAccessTokenFromDefaults()
        }
        if self.accessToken != nil {
            headers["Authorization"] = "\(self.accessToken!.TokenType) \(self.accessToken!.Token)"
        }
        Alamofire.upload(.POST, uploadFileUrl,
                         headers: headers,
                         multipartFormData: { multipartFormData in
                            multipartFormData.appendBodyPart(data: file.Data!, name: file.Filename!, fileName: file.Filename!, mimeType: file.ContentType!)
            },
                         encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON { response in
                                    switch response.result {
                                    case .Success(let json):
                                        let res = json as! NSDictionary
                                        let finalResult = MultipleResult<UploadFileResult>(dictionary: res)
                                        completionHandler(Result.Success(finalResult))
                                    case .Failure(let err):
                                        completionHandler(Result.Failure(err))
                                    }
                                }
                            case .Failure( _):
                                completionHandler(Result.Failure(NSError(domain: "NaN", code: 123, userInfo: nil)))
                            }
        })
    }
    
    func getAccessTokenFromDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(self.tokenKey) as? NSData {
            let tokenDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String:AnyObject]
            let accessToken = AccessToken(dictionary: tokenDict!)
            self.accessToken = accessToken
        }
    }
    
    func saveAccessToken(token: AccessToken){
        self.accessToken = token
        var tokenDict:[String:AnyObject] = [:]
        tokenDict["Token"] = self.accessToken?.Token
        tokenDict["ExpirationDate"] = self.accessToken?.ExpirationDate
        tokenDict["PrincipalId"] = self.accessToken?.PrincipalId
        tokenDict["TokenType"] = self.accessToken?.TokenType
        
        let tokenData:NSData = NSKeyedArchiver.archivedDataWithRootObject(tokenDict)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tokenData, forKey: self.tokenKey)
        defaults.synchronize()
    }
    
    func clearAccessToken(){
        self.accessToken = nil
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(self.tokenKey)
        defaults.synchronize()
    }
    
    private func prepareUrl(url: String) -> String {
        let finalUrl = self.baseUrl + self.apiVersion + "/\(self.appId)/" + url
        return finalUrl
    }
    
    private func prepareRequest(evRequest: EverliveRequest) -> NSMutableURLRequest {
        let url = self.prepareUrl(evRequest.url);
        evRequest.setUrl(url)
        
        if self.accessToken == nil {
            self.getAccessTokenFromDefaults()
        }
        
        if self.accessToken != nil {
            evRequest.setValue("\(self.accessToken!.TokenType) \(self.accessToken!.Token)", forHeader: "Authorization")
        }
        
        let nsRequest = evRequest.prepareRequest()
        return nsRequest
    }
    
}