//
//  DownloadFileHandler.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 4/4/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection

public class DownloadFileHandler : BaseHandler{
    var id: String
    
    required public init(id:String, connection: EverliveConnection, typeName: String){
        self.id = id
        super.init(connection: connection, typeName: typeName)
    }
    
    required public init(connection: EverliveConnection, typeName: String) {
        fatalError("init(connection:typeName:) has not been implemented")
    }
    
    public func execute(completionHandler: (File?, EverliveError?) -> Void){
        let url = self.prepareUrl()
        let getByIdRequest = EverliveRequest(httpMethod: "GET", url: url)
        
        self.connection.executeRequest(getByIdRequest) { (response: Result<SingleResult<File>, NSError>) -> Void in
            if let result = response.value {
                let request = NSMutableURLRequest(URL: NSURL(string: (result.data?.Uri)!)!)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    result.data?.Data = data
                    completionHandler(result.data, result.getErrorObject())
                })
                task.resume()
            }
        }
    }
    
    public override func prepareUrl() -> String {
        let url = super.prepareUrl()
        return url + "/\(self.id)"
    }
}