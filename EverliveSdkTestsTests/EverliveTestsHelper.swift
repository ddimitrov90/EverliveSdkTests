//
//  EverliveTestsHelper.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation
import EverliveSDK
import XCTest


public class EverliveTestsHelper {
    
    public static func assertBookFields(expectedBook: Book, resultBook: Book?, checkId: Bool = false){
        XCTAssertNotNil(resultBook)
        XCTAssertNotNil(resultBook!.Id)
        XCTAssertNotNil(resultBook!.CreatedAt)
        XCTAssertTrue(resultBook!.Title == expectedBook.Title, "Expected \(resultBook!.Title) to equal \(expectedBook.Title)")
        if(checkId){
            XCTAssertTrue(resultBook!.Id == expectedBook.Id, "Expected \(resultBook!.Id) to equal \(expectedBook.Id)")
        }
        XCTAssertTrue(resultBook!.Likes == expectedBook.Likes, "Expected \(resultBook!.Likes) to equal \(expectedBook.Likes)")
        XCTAssertNotNil(resultBook!.PublishedAt)
    }
    
    public static func assertUpdateResult(result:UpdateResult, error:EverliveError?, expectation: XCTestExpectation, resultCount: Int){
        XCTAssertNotNil(result.Result)
        XCTAssertNotNil(result.ModifiedAt)
        XCTAssertNil(error)
        XCTAssertTrue(result.Result == resultCount)
        expectation.fulfill()
    }
    
    public static func assertDeleteResult(deletedItems: Int?, error: EverliveError?, expectation: XCTestExpectation, resultCount: Int){
        XCTAssertNotNil(deletedItems)
        XCTAssertNil(error)
        XCTAssertTrue(deletedItems! == resultCount)
        expectation.fulfill()
    }
    
    public static func assertUnauthorized(eventName:String, everliveError: EverliveError?){
        XCTAssertNotNil(everliveError)
        XCTAssertTrue((everliveError?.ErrorCode)! == "603", "Expected \((everliveError?.ErrorCode)!) to equal 603")
        XCTAssertTrue((everliveError?.Message)! == "\(eventName) access on type \'BannedBooks\' denied for anonymous user.", "\((everliveError?.Message)!) to equal \(eventName) access on type \'BannedBooks\' denied for anonymous user.")
    }
}