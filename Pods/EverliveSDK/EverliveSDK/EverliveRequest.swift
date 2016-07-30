//
//  Request.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire

public class EverliveRequest {
    var method:String
    var url:String
    var body: NSData?
    var headers: [String: String]?

    public convenience init(httpMethod: String, url: String){
        self.init(httpMethod: httpMethod, url: url, body: nil, headers: nil)
    }
    
    public convenience init(httpMethod: String, url: String, headers: [String: String]){
        self.init(httpMethod: httpMethod, url: url, body: nil, headers: headers)
    }
    
    public convenience init(httpMethod: String, url: String, body: NSData){
        self.init(httpMethod: httpMethod, url: url, body: body, headers: nil)
    }
    
    public init(httpMethod:String, url: String, body: NSData?, headers: [ String: String]?){
        self.method = httpMethod
        self.url = url
        self.body = body
        if headers != nil {
            self.headers = headers
        } else {
            self.headers = [:]
        }
    }
    
    public func setValue(value:String, forHeader: String){
        if self.headers == nil {
            self.headers = [:]
        }
        self.headers![forHeader] = value
    }
    
    public func setBodyData(data:NSData) {
        self.body = data
    }
    
    public func setUrl(url:String) {
        self.url = url
    }
    
    public func applyFilter(filter:String){
        if(filter != ""){
            self.headers!["X-Everlive-Filter"] = filter
        }
        
    }
    
    public func applyPaging(pagingObj:Paging?) {
        if let paging = pagingObj {
            if let skip = paging.skip where skip > 0 {
                self.headers!["X-Everlive-Skip"] = String(skip)
            }
            if let take = paging.take where take > 0 {
                self.headers!["X-Everlive-Take"] = String(take)
            }
        }
    }
    
    public func applySorting(sortObject: Sorting?) {
        if let sorting = sortObject {
            let sortingValue = sorting.getSortObject()
            if sortingValue != "" {
                self.headers!["X-Everlive-Sort"] = sortingValue
            }
        }
    }
    
    public func applyExpand(expandObj: QueryProtocol?){
        if let expand = expandObj {
            let expDefinition = expand.getJson()
            if expDefinition != "" {
                self.headers!["X-Everlive-Expand"] = expDefinition
            }
        }
    }
    
    public func prepareRequest() -> NSMutableURLRequest {
        let url = NSURL(string: self.url);
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = self.method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = self.headers {
            for (header, value) in headers {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        
        if let bodyData = self.body {
            request.HTTPBody = bodyData
        }
        
        return request;
    }
}