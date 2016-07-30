//
//  AlamofireExtensions.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

extension Alamofire.Request {
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response object (of type Mappable) and any error produced while making the request
     
     - returns: The request.
     */
    public func responseObject<T:EVObject>(completionHandler: (Result<T, NSError>) -> Void) -> Self {
        return responseObject(nil) { (request, response, data) in
            completionHandler(data)
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.
     
     - returns: The request.
     */
    public func responseObject<T:EVObject>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<T, NSError>) -> Void) -> Self {
        return responseObject(nil) { (request, response, data) in
            completionHandler(request, response, data)
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.
     
     - returns: The request.
     */
    public func responseObject<T:EVObject>(queue: dispatch_queue_t?, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<T, NSError>) -> Void) -> Self {
        return responseJSON(completionHandler: { (response) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(queue ?? dispatch_get_main_queue()) {
                    switch response.result {
                    case .Success(let json):
                        let t = T()
                        EVReflection.setPropertiesfromDictionary(json as! NSDictionary, anyObject: t)
                            completionHandler(self.request, self.response, Result.Success(t))
                    case .Failure(let error):
                        completionHandler(self.request, self.response, Result.Failure(error ?? NSError(domain: "NaN", code: 1, userInfo: nil)))
                    }
                }
            }
            
        })
    }
}