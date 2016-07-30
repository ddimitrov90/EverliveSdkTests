//
//  FilesHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 4/4/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EVReflection

public class FilesHandler {
    var connection: EverliveConnection
    var typeName: String!
    
    init(connection: EverliveConnection){
        self.connection = connection
        self.typeName = "Files"
        //TODO: discuss the time format
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        EVReflection.setDateFormatter(formatter)
    }
    
    public func download(id:String)-> DownloadFileHandler {
        return DownloadFileHandler(id: id, connection: self.connection, typeName: self.typeName)
    }
    
    public func upload(file: File) -> UploadFileHandler {
        return UploadFileHandler(newFile: file, connection: self.connection, typeName: self.typeName)
    }
    
    public func getById(id:String)-> GetByIdHandler<File> {
        return GetByIdHandler(id: id, connection: self.connection, typeName: self.typeName)
    }
    
    public func getAll() -> GetAllHandler<File> {
        return GetAllHandler(connection: self.connection, typeName: self.typeName)
    }
    
    public func getByFilter(filter: EverliveQuery) -> GetByFilter<File>{
        return GetByFilter(filter: filter, connection: self.connection, typeName: self.typeName)
    }
    
    public func deleteById(id:String) -> DeleteByIdHandler{
        return DeleteByIdHandler(id: id, connection: self.connection, typeName: self.typeName)
    }
    
    public func deleteAll() -> DeleteAllHandler {
        return DeleteAllHandler(connection: self.connection, typeName: self.typeName)
    }
    
    
    
}