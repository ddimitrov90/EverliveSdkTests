//
//  GetAllHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/17/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection


public class GetAllHandler<T: DataItem> : BaseHandler {
    var paging: Paging?
    var sorting: Sorting?
    var expand:QueryProtocol?
    
    required public init(connection: EverliveConnection, typeName: String){
        super.init(connection: connection, typeName: typeName)
    }
    
    public func execute(completionHandler: ([T]?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let getAllRequest = EverliveRequest(httpMethod: "GET", url: url)
        getAllRequest.applyPaging(self.paging)
        getAllRequest.applySorting(self.sorting)
        getAllRequest.applyExpand(self.expand)
        
        self.connection.executeRequest(getAllRequest) { (response: Result<MultipleResult<T>, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result.data, result.getErrorObject())
            }
        }
    }
    
    public func sort(sortDefinition: Sorting) -> GetAllHandler<T> {
        self.sorting = sortDefinition
        return self
    }
    
    public func skip(skipNumber:Int) -> GetAllHandler<T> {
        if self.paging == nil {
            self.paging = Paging()
        }
        self.paging?.skip = skipNumber
        return self
    }
    
    public func take(takeNumber:Int) -> GetAllHandler<T> {
        if self.paging == nil {
            self.paging = Paging()
        }
        self.paging?.take = takeNumber
        return self
    }
    
    public func expand(expandObj: ExpandDefinition) -> GetAllHandler<T> {
        self.expand = expandObj
        return self
    }
    
    public func expand(multipleExpand: MultipleExpandDefinition) -> GetAllHandler<T> {
        self.expand = multipleExpand
        return self
    }
}