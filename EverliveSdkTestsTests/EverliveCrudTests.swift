//
//  EverliveSwiftTests.swift
//  EverliveSwiftTests
//
//  Created by Dimitar Dimitrov on 2/27/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import XCTest
import EverliveSDK

class EverliveCrudTests: XCTestCase {
    
    let everliveApp = EverliveApp(appId: "y843lqyw2rn3fwyd")
    var itemId:String = "ae7a31a0-de03-11e5-81b2-ff4a945ca321"
    let timeout = 5.0
    var singleBook: Book = Book()
    var multipleBooks: [Book] = []
    
    override func setUp() {
        super.setUp()
        self.singleBook = Book()
        self.singleBook.Id = self.itemId
        self.singleBook.Title = "Lolita"
        self.singleBook.Likes = 10
        self.singleBook.PublishedAt = NSDate.init()
        
        let newItem = Book()
        newItem.Title = "Warcraft"
        newItem.Likes = 20
        newItem.PublishedAt = NSDate.init()
        
        let newItem2 = Book()
        newItem2.Title = "Crime and Punishment"
        newItem2.Likes = 30
        newItem2.PublishedAt = NSDate.init()
        
        let newItem3 = Book()
        newItem3.Title = "Frankenstein"
        newItem3.Likes = 40
        newItem3.PublishedAt = NSDate.init()
        
        let newItem4 = Book()
        newItem4.Title = "Game of Thrones"
        newItem4.Likes = 50
        newItem4.PublishedAt = NSDate.init()
        
        self.multipleBooks = [newItem, newItem2, newItem3, newItem4]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test1_CreateOneItem() {
        let asyncExpectation = expectationWithDescription("createItem")
        self.everliveApp.Data().create(self.singleBook).execute { (success:Bool, error: EverliveError?) -> Void in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            EverliveTestsHelper.assertBookFields(self.singleBook, resultBook: self.singleBook, checkId: true)
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
        
    }
    
    func test2_CreateMultipleItems(){
        let asyncExpectation = expectationWithDescription("createMultipleItems")
        
        self.everliveApp.Data().create(self.multipleBooks).execute { ( result: [Book], error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result.count == 4)
            for index in 0...result.count-1 {
                EverliveTestsHelper.assertBookFields(self.multipleBooks[index], resultBook: result[index])
            }
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test3_ReadById() {
        XCTAssertNotNil(self.itemId)
        let asyncExpectation = expectationWithDescription("readById")
        everliveApp.Data().getById(self.itemId).execute { (result: Book?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            EverliveTestsHelper.assertBookFields(self.singleBook, resultBook: result)
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test4_ReadAll() {
        let asyncExpectation = expectationWithDescription("readAll")
        everliveApp.Data().getAll().execute { (result: [Book]?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result!.count == 5)
            EverliveTestsHelper.assertBookFields(self.singleBook, resultBook: result![0])
            for index in 1...result!.count-1 {
                EverliveTestsHelper.assertBookFields(self.multipleBooks[index-1], resultBook: result![index])
            }
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test4_ReadAllAndSort() {
        let asyncExpectation = expectationWithDescription("readAllAndSort")
        let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Descending)
        
        everliveApp.Data().getAll().sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result!.count == 5)
            EverliveTestsHelper.assertBookFields(self.singleBook, resultBook: result![4])
            for index in 0...result!.count-2 {
                EverliveTestsHelper.assertBookFields(self.multipleBooks[index], resultBook: result![result!.count-2-index])
            }
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test4_ReadAllAndSkipTake1() {
        let asyncExpectation = expectationWithDescription("readAllAndSkipTake1")
        let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Ascending)
        
        everliveApp.Data().getAll().skip(2).take(1).sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result!.count == 1)
            EverliveTestsHelper.assertBookFields(self.multipleBooks[1], resultBook: result![0])
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test4_ReadAllAndSkipTake2() {
        let asyncExpectation = expectationWithDescription("readAllAndSkipTake2")
        let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Ascending)
        
        everliveApp.Data().getAll().skip(1).take(2).sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result!.count == 2)
            EverliveTestsHelper.assertBookFields(self.multipleBooks[0], resultBook: result![0])
            EverliveTestsHelper.assertBookFields(self.multipleBooks[1], resultBook: result![1])
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    
    func test5_ReadByFilter() {
        let asyncExpectation = expectationWithDescription("readByFilter")
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 20.0, orEqual: true)
        
        everliveApp.Data().getByFilter(query).execute { (result: [Book]?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result!.count == 4)
            for index in 0...result!.count-1 {
                EverliveTestsHelper.assertBookFields(self.multipleBooks[index], resultBook: result![index])
            }
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test5_ReadByFilterAndSort() {
        let asyncExpectation = expectationWithDescription("readByFilter")
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 20.0, orEqual: true)
        let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Descending)
        
        everliveApp.Data().getByFilter(query).sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result!.count == 4)
            for index in 0...result!.count-1 {
                EverliveTestsHelper.assertBookFields(self.multipleBooks[index], resultBook: result![result!.count-1-index])
            }
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test5_ReadByFilterAndSkipTake() {
        let asyncExpectation = expectationWithDescription("readByFilter")
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 20.0, orEqual: true)
        let sortDef = Sorting(fieldName: "Likes", orderDirection: OrderDirection.Ascending)
        
        everliveApp.Data().getByFilter(query).skip(1).take(2).sort(sortDef).execute { (result: [Book]?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result!.count == 2)
            EverliveTestsHelper.assertBookFields(self.multipleBooks[1], resultBook: result![0])
            EverliveTestsHelper.assertBookFields(self.multipleBooks[2], resultBook: result![1])
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test5_ReadCount() {
        let asyncExpectation = expectationWithDescription("readCount")
        let dataHandler: DataHandler<Book> = everliveApp.Data()
        dataHandler.getCount().execute { (count:Int?, err:EverliveError?) -> Void in
            XCTAssertNotNil(count)
            XCTAssertNil(err)
            XCTAssertTrue(count! == 5)
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test5_ReadCountByFilter() {
        let asyncExpectation = expectationWithDescription("readCount")
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 25, orEqual: false)
        
        let dataHandler: DataHandler<Book> = everliveApp.Data()
        dataHandler.getCountByFilter(query).execute { (count:Int?, err:EverliveError?) -> Void in
            XCTAssertNotNil(count)
            XCTAssertNil(err)
            XCTAssertTrue(count! == 3)
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test6_ReadAndUpdateById() {
        XCTAssertNotNil(self.itemId)
        let asyncExpectation = expectationWithDescription("readById")
        everliveApp.Data().getById(self.itemId).execute { (result: Book?, error: EverliveError?) -> Void in
            result!.Title = "Lolita 2"
            result!.Likes = 11
            let updateHandler: DataHandler<Book> = self.everliveApp.Data()
            updateHandler.updateById(self.itemId, updateObject: result!).execute { (result:UpdateResult, error:EverliveError?) -> Void in
                EverliveTestsHelper.assertUpdateResult(result, error: error, expectation: asyncExpectation, resultCount: 1)
            }
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test6_UpdateByIdWithUpdateObject() {
        XCTAssertNotNil(self.itemId)
        let asyncExpectation = expectationWithDescription("updateById")
        
        let updateObject = UpdateObject(updateFields: [])
        updateObject.UpdatedFields.append(UpdateField(fieldName: "Likes", modifier: UpdateModifier.Increment, value: 5))
        
        let updateHandler: DataHandler<Book> = everliveApp.Data()
        updateHandler.updateById(self.itemId, updateObject: updateObject).execute { (result:UpdateResult, error:EverliveError?) -> Void in
            EverliveTestsHelper.assertUpdateResult(result, error: error, expectation: asyncExpectation, resultCount: 1)
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test6_UpdateByIdWithDataItem() {
        XCTAssertNotNil(self.itemId)
        let asyncExpectation = expectationWithDescription("updateById")
        
        let book = Book()
        book.Likes = 17
        
        let updateHandler: DataHandler<Book> = everliveApp.Data()
        updateHandler.updateById(self.itemId, updateObject: book).execute { (result:UpdateResult, error:EverliveError?) -> Void in
            EverliveTestsHelper.assertUpdateResult(result, error: error, expectation: asyncExpectation, resultCount: 1)
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test7_UpdateByFilterWithUpdateObject() {
        let asyncExpectation = expectationWithDescription("updateByFilter")
        
        let updateObject = UpdateObject(updateFields: [])
        updateObject.UpdatedFields.append(UpdateField(fieldName: "Likes", modifier: UpdateModifier.Increment, value: 2))
        
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 25, orEqual: false)
        
        let updateHandler: DataHandler<Book> = everliveApp.Data()
        updateHandler.updateByFilter(query, updateObject: updateObject).execute { (result:UpdateResult, error:EverliveError?) -> Void in
            EverliveTestsHelper.assertUpdateResult(result, error: error, expectation: asyncExpectation, resultCount: 3)
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test7_UpdateByFilterWithDataItem() {
        XCTAssertNotNil(self.itemId)
        let asyncExpectation = expectationWithDescription("updateByFilter")
        
        let book = Book()
        book.Title = "Changed Title"
        
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 25, orEqual: false)
        
        let updateHandler: DataHandler<Book> = everliveApp.Data()
        updateHandler.updateByFilter(query, updateObject: book).execute { (result:UpdateResult, error:EverliveError?) -> Void in
            EverliveTestsHelper.assertUpdateResult(result, error: error, expectation: asyncExpectation, resultCount: 3)
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test8_DeleteById() {
        XCTAssertNotNil(self.itemId)
        let asyncExpectation = expectationWithDescription("deleteById")
        
        let deleteHandler: DataHandler<Book> = everliveApp.Data()
        deleteHandler.deleteById(self.itemId).execute { (deletedItems: Int?, error: EverliveError?) -> Void in
            EverliveTestsHelper.assertDeleteResult(deletedItems, error: error, expectation: asyncExpectation, resultCount: 1)
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test9_DeteteAll() {
        let asyncExpectation = expectationWithDescription("deleteAll")
        
        let deleteHandler: DataHandler<Book> = everliveApp.Data()
        deleteHandler.deleteAll().execute { (deletedItems: Int?, error: EverliveError?) -> Void in
            EverliveTestsHelper.assertDeleteResult(deletedItems, error: error, expectation: asyncExpectation, resultCount: 4)
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
}
