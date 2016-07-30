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
import SwiftyJSON

public class UploadFileHandler : BaseHandler{
    var item: File
    
    public init(newFile: File, connection: EverliveConnection, typeName: String){
        self.item = newFile
        super.init(connection: connection, typeName: typeName)
    }
    
    required public init(connection: EverliveConnection, typeName: String) {
        fatalError("init(connection:typeName:) has not been implemented")
    }
    
    public func execute(completionHandler: (Bool, EverliveError?) -> Void){
        self.connection.uploadFile(self.item) { (response: Result<MultipleResult<UploadFileResult>, NSError>) -> Void in
            if let result = response.value {
                var success = false
                let errorObject = result.getErrorObject()
                if errorObject == nil {
                    self.item.Id = result.data[0].Id
                    self.item.CreatedAt = result.data[0].CreatedAt
                    self.item.Uri = result.data[0].Uri
                    success = true
                }
                completionHandler(success, result.getErrorObject())
            }
        }
    }
}