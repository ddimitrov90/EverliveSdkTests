//
//  DataHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 2/15/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection


public class DataHandler<T : DataItem> {
    var connection: EverliveConnection
    var typeName: String!
    
    init(connection: EverliveConnection){
        self.connection = connection
        self.typeName = self.getTypeName()
        //TODO: discuss the time format
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        EVReflection.setDateFormatter(formatter)
    }
    
    
    public func getById(id:String)-> GetByIdHandler<T> {
        return GetByIdHandler(id: id, connection: self.connection, typeName: self.typeName)
    }
    
    public func getAll() -> GetAllHandler<T> {
        return GetAllHandler(connection: self.connection, typeName: self.typeName)
    }
    
    public func getByFilter(filter: EverliveQuery) -> GetByFilter<T>{
        return GetByFilter(filter: filter, connection: self.connection, typeName: self.typeName)
    }
    
    public func create(item: T) -> CreateSingleHandler<T> {
        return CreateSingleHandler(newItem: item, connection: self.connection, typeName: self.typeName)
    }
    
    public func create(items: [T]) -> CreateMultipleHandler<T> {
        return CreateMultipleHandler(newItems: items, connection: self.connection, typeName: self.typeName)
    }
    
    public func deleteById(id:String) -> DeleteByIdHandler{
        return DeleteByIdHandler(id: id, connection: self.connection, typeName: self.typeName)
    }
    
    public func deleteAll() -> DeleteAllHandler {
        return DeleteAllHandler(connection: self.connection, typeName: self.typeName)
    }
    
    public func updateById(id:String, updateObject: Updateable) -> UpdateByIdHandler {
        return UpdateByIdHandler(id: id, updateObject: updateObject, connection: self.connection, typeName: self.typeName)
    }
    
    public func updateByFilter(query: QueryProtocol, updateObject: Updateable) -> UpdateByFilterHandler {
        return UpdateByFilterHandler(query: query, updateObject: updateObject, connection: self.connection, typeName: self.typeName)
    }
    
    public func update(item: T) -> UpdateByIdHandler {
        let itemId = (item as DataItem).Id
        return UpdateByIdHandler(id: itemId!, updateObject: item, connection: self.connection, typeName: self.typeName)
    }
    
    public func getCount() -> GetCountHandler {
        return GetCountHandler(connection: self.connection, typeName: self.typeName)
    }
    
    public func getCountByFilter(filter:QueryProtocol) -> GetCountHandler{
        return GetCountHandler(filter: filter, connection: self.connection, typeName: self.typeName)
    }
    
    private func getTypeName() -> String {
        let currentType = T()
        let typeName = currentType.getTypeName()
        if  typeName != "" {
            return typeName
        } else {
            let fullName: String = NSStringFromClass(T.self as AnyClass)
            let range = fullName.rangeOfString(".", options: .BackwardsSearch)
            if let range = range {
                return fullName.substringFromIndex(range.endIndex)
            } else {
                return fullName
            }
        }
    }
}