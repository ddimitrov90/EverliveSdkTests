//
//  UsersCrudTests.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/12/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import XCTest
import EverliveSDK

class EverliveUsersCrudTests: XCTestCase {
    let everliveApp = EverliveApp(appId: "y843lqyw2rn3fwyd")
    let itemId = "6b519980-97ed-11e3-b55b-33afbdcdcf75"
    let timeout = 5.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test01_CreateUser() {
        let newUser = User()
        newUser.Id = self.itemId
        newUser.Username = "User1"
        newUser.Password = "User1Password"
        newUser.Email = "user1@everliveswift.com"
        newUser.DisplayName = "User1Display"
        
        let asyncExpectation = expectationWithDescription("createUser")
        
        self.everliveApp.Users().create(newUser).execute { (success:Bool, error: EverliveError?) -> Void in
            XCTAssertTrue(success)
            XCTAssertNotNil(newUser.Id)
            XCTAssertNotNil(newUser.CreatedAt)
            XCTAssertTrue(newUser.Username == "User1")
            XCTAssertTrue(newUser.Id == self.itemId)
            XCTAssertTrue(newUser.Email == "user1@everliveswift.com")
            XCTAssertTrue(newUser.DisplayName == "User1Display")
            XCTAssertTrue(newUser.IsVerified == false)
            XCTAssertNil(newUser.SecretAnswer)
            XCTAssertNil(newUser.SecretQuestionId)
            XCTAssertNil(error)
            
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    /*
    func test02_CreateUserWithSecret() {
        let newUser = User()
        newUser.Username = "User2"
        newUser.Password = "User2Password"
        newUser.Email = "user2@everliveswift.com"
        newUser.DisplayName = "User2Display"
        newUser.SecretQuestionId = "Some-Id-Here"
        newUser.SecretAnswer = "Very Secret Answer"
        
        let asyncExpectation = expectationWithDescription("createUserWithSecret")
        
        self.everliveApp.Users().create(newUser).execute { (success:Bool, error: EverliveError?) -> Void in
            XCTAssertTrue(success)
            XCTAssertNotNil(newUser.Id)
            XCTAssertNotNil(newUser.CreatedAt)
            XCTAssertTrue(newUser.Username == "User2")
            XCTAssertTrue(newUser.Email == "user2@everliveswift.com")
            XCTAssertTrue(newUser.DisplayName == "User2Display")
            XCTAssertTrue(newUser.IsVerified == false)
            XCTAssertNil(newUser.SecretAnswer)
            XCTAssertNil(newUser.SecretQuestionId)
            XCTAssertNil(error)
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    */
    func test02_CreateMultipleUsers(){
        
        var users:[User] = []
        for index in 3...6 {
            let newUser = User()
            newUser.Username = "User\(index)"
            newUser.Password = "User\(index)Password"
            newUser.Email = "user\(index)@everliveswift.com"
            newUser.DisplayName = "User\(index)Display"
            users.append(newUser)
        }
        
        let asyncExpectation = expectationWithDescription("createMultipleItems")
        
        self.everliveApp.Data().create(users).execute { ( result: [User], error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result.count == 4)
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error)
        }
    }
    
    
    
    func test30_ReadById() {
        XCTAssertNotNil(self.itemId)
        let asyncExpectation = expectationWithDescription("readById")
        everliveApp.Users().getById(self.itemId).execute { (result: User?, error: EverliveError?) -> Void in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertTrue(result?.Id == self.itemId)
            XCTAssertTrue(result?.Username == "User1")
            XCTAssertTrue(result?.DisplayName == "User1Display")
            XCTAssertNotNil(result?.Email == "mitko2@mitko.com")
            XCTAssertNotNil(result?.RoleId == "776224e0-9669-11e3-a129-f95892bf5a09")
            XCTAssertNotNil(result?.IsVerified == false)
            XCTAssertNotNil(result?.Password == "")
            XCTAssertNil(result?.SecretQuestionId)
            XCTAssertNil(result?.SecretAnswer)
            XCTAssertNotNil(result?.ModifiedAt)
            XCTAssertNotNil(result?.CreatedAt)
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    
    
}
