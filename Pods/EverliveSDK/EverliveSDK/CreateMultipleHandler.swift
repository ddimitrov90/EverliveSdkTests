//
//  CreateSingleHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/17/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

public class CreateMultipleHandler<T: DataItem> : BaseHandler{
    var items: [T]
    
    required public init(newItems: [T], connection: EverliveConnection, typeName: String){
        self.items = newItems
        super.init(connection: connection, typeName: typeName)
    }
    
    public func execute(completionHandler: ([T], EverliveError?) -> Void){
        let url = self.prepareUrl()
        let bodyData = self.prepareData()
        let createRequest = EverliveRequest(httpMethod: "POST", url: url, body: bodyData)
        
        self.connection.executeRequest(createRequest) { (response: Result<MultipleResult<T>, NSError>) -> Void in
            if let result = response.value {
                self.prepareResult(result.data)
                completionHandler(self.items, result.getErrorObject())
            }
        }
    }
    
    private func prepareResult(resultItems: [T]){
        for index in 0...self.items.count-1 {
            self.items[index].Id = resultItems[index].Id
            self.items[index].CreatedAt = resultItems[index].CreatedAt
        }
    }
    
    private func prepareData() -> NSData {
        let resultData = NSMutableData()
        resultData.appendData("[".dataUsingEncoding(NSUTF8StringEncoding)!)
        for index in 0...self.items.count-1 {
            let tempBody: String = EVReflection.toJsonString(self.items[index])
            let data = tempBody.dataUsingEncoding(NSUTF8StringEncoding)
            resultData.appendData(data!)
            if index != self.items.count - 1{
                resultData.appendData(",".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        resultData.appendData("]".dataUsingEncoding(NSUTF8StringEncoding)!)
        return resultData
    }
}