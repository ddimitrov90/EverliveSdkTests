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


public class GetByFilter<T: DataItem> : BaseHandler, FilterProtocol {
    var filter: QueryProtocol
    var paging: Paging?
    var sorting: Sorting?
    var expand: QueryProtocol?
    
    required public init(filter: QueryProtocol, connection: EverliveConnection, typeName: String){
        self.filter = filter
        super.init(connection: connection, typeName: typeName)
    }
    
    public func execute(completionHandler: ([T]?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let getByFilterRequest = EverliveRequest(httpMethod: "GET", url: url)
        self.prepareFilter(getByFilterRequest)
        getByFilterRequest.applyPaging(self.paging)
        getByFilterRequest.applySorting(self.sorting)
        getByFilterRequest.applyExpand(self.expand)
        
        self.connection.executeRequest(getByFilterRequest) { (response: Result<MultipleResult<T>, NSError>) -> Void in
            if let result = response.value {
                completionHandler(result.data, result.getErrorObject())
            }
        }
    }
    
    public func prepareFilter(request:EverliveRequest) -> Void {
        let filterString = self.filter.getJson()
        request.applyFilter(filterString)
    }
    
    public func sort(sortDefinition: Sorting) -> GetByFilter<T> {
        self.sorting = sortDefinition
        return self
    }
    
    public func skip(skipNumber:Int) -> GetByFilter<T> {
        if self.paging == nil {
            self.paging = Paging()
        }
        self.paging?.skip = skipNumber
        return self
    }
    
    public func take(takeNumber:Int) -> GetByFilter<T> {
        if self.paging == nil {
            self.paging = Paging()
        }
        self.paging?.take = takeNumber
        return self
    }
    
    public func expand(expandObj: ExpandDefinition) -> GetByFilter<T> {
        self.expand = expandObj
        return self
    }
    
    public func expand(multipleExpand: MultipleExpandDefinition) -> GetByFilter<T> {
        self.expand = multipleExpand
        return self
    }
}