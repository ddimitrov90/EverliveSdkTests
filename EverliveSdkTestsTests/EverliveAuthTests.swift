//
//  EverliveAuthTests.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/13/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import XCTest
import EverliveSDK

class EverliveAuthTests: XCTestCase {
    let everliveApp = EverliveApp(appId: "y843lqyw2rn3fwyd")
    let timeout = 5.0
    var isLoggedIn: Bool = false
    
    override func setUp() {
        super.setUp()
        self.createUser()
    }
    
    override func tearDown() {
        if self.isLoggedIn {
            self.logoutUser()
        }
        self.dropUser()
        super.tearDown()
    }
    
    func test01_loginUserReturnAccessToken(){
        let asyncExpectation = expectationWithDescription("testLogin")
        self.everliveApp.Authentication().login("AuthTest", password: "AuthTestPassword").execute({ (token: AccessToken?, error: EverliveError?) -> Void in
            XCTAssertNotNil(token)
            XCTAssertTrue(token!.Token != "")
            XCTAssertNotNil(token!.PrincipalId)
            self.isLoggedIn = true
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test02_loginWithInvalidCredentials(){
        let asyncExpectation = expectationWithDescription("testLogin")
        self.everliveApp.Authentication().login("InvalidUser", password: "InvalidPassword").execute({ (token: AccessToken?, error: EverliveError?) -> Void in
            XCTAssertNil(token)
            XCTAssertNotNil(error)
            XCTAssertTrue((error?.ErrorCode)! == "205", "Expected \((error?.ErrorCode)!) to equal 205")
            XCTAssertTrue((error?.Message)! == "Invalid username or password.")
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test03_getMeAfterLoginReturnsUser(){
        self.loginUser()
        let asyncExpectation = expectationWithDescription("testLogin")
        self.everliveApp.Users().getMe().execute({ (user: User?, getMeError:EverliveError?) -> Void in
            XCTAssertNotNil(user)
            XCTAssertTrue(user?.Username == "AuthTest")
            self.isLoggedIn = true
            XCTAssertNil(getMeError)
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test04_getMeAfterLogoutIsNotAuthenticated(){
        self.loginUser()
        self.logoutUser()
        let asyncExpectation = expectationWithDescription("testLogin")
        self.everliveApp.Users().getMe().execute({ (user: User?, getMeError:EverliveError?) -> Void in
            XCTAssertNil(user)
            XCTAssertTrue((getMeError?.ErrorCode)! == "601", "Expected \((getMeError?.ErrorCode)!) to equal 601")
            XCTAssertTrue((getMeError?.Message)! == "Invalid request.")
            asyncExpectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test05_createItems(){
        self.createItems(false)
        self.createItems(true)
    }
    
    private func createItems(withAuth: Bool) {
        let singleBook = BannedBook()
        singleBook.Title = "Lolita"
        singleBook.Likes = 10
        singleBook.PublishedAt = NSDate.init()
        
        if(withAuth){
            self.loginUser()
            self.isLoggedIn = true
        }
        
        let asyncExpectation = expectationWithDescription("createItem")
        self.everliveApp.Data().create(singleBook).execute { (success:Bool, error: EverliveError?) -> Void in
            if(withAuth){
                XCTAssertTrue(success)
                XCTAssertNil(error)
            } else {
                XCTAssertFalse(success)
                EverliveTestsHelper.assertUnauthorized("CREATE", everliveError: error)
            }
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test06_readItems(){
        self.readItems(false)
        self.readItems(true)
    }
    
    private func readItems(withAuth: Bool){
        if(withAuth){
            self.loginUser()
            self.isLoggedIn = true
        }
        
        let asyncExpectation = expectationWithDescription("readAll")
        everliveApp.Data().getAll().execute { (result: [BannedBook]?, error: EverliveError?) -> Void in
            if(withAuth){
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                XCTAssertTrue(result!.count > 0)
            } else {
                XCTAssertTrue(result!.count == 0)
                EverliveTestsHelper.assertUnauthorized("READ", everliveError: error)
            }
            
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test07_updateItems(){
        self.updateItems(false)
        self.updateItems(true)
    }
    
    private func updateItems(withAuth: Bool) {
        if(withAuth){
            self.loginUser()
            self.isLoggedIn = true
        }
        let asyncExpectation = expectationWithDescription("updateByFilter")
        
        let updateObject = UpdateObject(updateFields: [])
        updateObject.UpdatedFields.append(UpdateField(fieldName: "Likes", modifier: UpdateModifier.Increment, value: 2))
        
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 5, orEqual: false)
        
        let updateHandler: DataHandler<BannedBook> = everliveApp.Data()
        updateHandler.updateByFilter(query, updateObject: updateObject).execute { (result:UpdateResult, error:EverliveError?) -> Void in
            if(withAuth){
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                XCTAssertTrue(result.Result > 0)
            } else {
                EverliveTestsHelper.assertUnauthorized("UPDATE", everliveError: error)
            }
            
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test08_deleteItems(withAuth: Bool) {
        self.deleteItems(false)
        self.deleteItems(true)
    }
    
    private func deleteItems(withAuth: Bool){
        if(withAuth){
            self.loginUser()
            self.isLoggedIn = true
        }
        let asyncExpectation = expectationWithDescription("deleteAll")
        
        let deleteHandler: DataHandler<Book> = everliveApp.Data()
        deleteHandler.deleteAll().execute { (deletedItems: Int?, error: EverliveError?) -> Void in
            if(withAuth){
                XCTAssertNotNil(deletedItems)
                XCTAssertNil(error)
                XCTAssertTrue(deletedItems > 0)
            } else {
                EverliveTestsHelper.assertUnauthorized("DELETE", everliveError: error)
            }
            
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func test09_verifyUser() {
        
    }
    
    private func createUser(){
        let newUser = User()
        newUser.Username = "AuthTest"
        newUser.Password = "AuthTestPassword"
        newUser.Email = "user1@everliveswift.com"
        newUser.DisplayName = "User1Display"
        
        let asyncExpectation = expectationWithDescription("createAuthUser")
        
        self.everliveApp.Users().create(newUser).execute { (success:Bool, error: EverliveError?) -> Void in
            XCTAssertTrue(success)
            XCTAssertNil(error, "Expected \(error) to be nil.")
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    private func dropUser(){
        let asyncExpectation = expectationWithDescription("dropAuthUser")
        let deleteUserHandler = self.everliveApp.Users().deleteAll()
        deleteUserHandler.execute { (deletedUsers: Int?, err: EverliveError?) -> Void in
            XCTAssertTrue(deletedUsers! == 1)
            XCTAssertNil(err)
            asyncExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    private func loginUser(){
        let asyncExpectation = expectationWithDescription("loginUser")
        self.everliveApp.Authentication().login("AuthTest", password: "AuthTestPassword").execute { (token: AccessToken?, err: EverliveError?) -> Void in
            XCTAssertNotNil(token)
            XCTAssertTrue(token!.Token != "")
            XCTAssertNotNil(token!.PrincipalId)
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    private func logoutUser(){
        let asyncExpectation = expectationWithDescription("logoutUser")
        self.everliveApp.Authentication().logout().execute { (success: Bool, err: EverliveError?) -> Void in
            XCTAssertTrue(success)
            self.isLoggedIn = false
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(self.timeout) { error in
            XCTAssertNil(error)
        }
    }
    
}
