//
//  EverliveQueryTests.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/2/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import XCTest
import EverliveSDK

class EverliveQueryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingle_neFloat(){
        let query = EverliveQuery()
        query.filter("Likes", notEqualTo: 20)
        let expectedQueryResult = "{\"Likes\":{\"$ne\":20}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_eqFloat(){
        let query = EverliveQuery()
        query.filter("Likes", equalTo: 20)
        let expectedQueryResult = "{\"Likes\":{\"$eq\":20}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_neString(){
        let query = EverliveQuery()
        query.filter("Title", notEqualTo: "Lolita")
        let expectedQueryResult = "{\"Title\":{\"$ne\":\"Lolita\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_eqString(){
        let query = EverliveQuery()
        query.filter("Title", equalTo: "Lolita")
        let expectedQueryResult = "{\"Title\":{\"$eq\":\"Lolita\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_neBool(){
        let query = EverliveQuery()
        query.filter("Title", notEqualTo: false)
        let expectedQueryResult = "{\"Title\":{\"$ne\":false}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_eqBool(){
        let query = EverliveQuery()
        query.filter("Title", equalTo: true)
        let expectedQueryResult = "{\"Title\":{\"$eq\":true}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_gt(){
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 20, orEqual: false)
        let expectedQueryResult = "{\"Likes\":{\"$gt\":20}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_gte(){
        let query = EverliveQuery()
        query.filter("Likes", greaterThan: 20, orEqual: true)
        let expectedQueryResult = "{\"Likes\":{\"$gte\":20}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_lt(){
        let query = EverliveQuery()
        query.filter("Likes", lessThan: 20, orEqual: false)
        let expectedQueryResult = "{\"Likes\":{\"$lt\":20}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_lte(){
        let query = EverliveQuery()
        query.filter("Likes", lessThan: 20, orEqual: true)
        let expectedQueryResult = "{\"Likes\":{\"$lte\":20}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_regexStartsWith(){
        let query = EverliveQuery()
        query.filter("Title", startsWith: "lol", caseSensitive: true)
        let expectedQueryResult = "{\"Title\":{\"$regex\":\"^lol\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_regexEndsWith(){
        let query = EverliveQuery()
        query.filter("Title", endsWith: "lol", caseSensitive: true)
        let expectedQueryResult = "{\"Title\":{\"$regex\":\"lol$\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_regexStartsWithCaseInsensitive(){
        let query = EverliveQuery()
        query.filter("Title", startsWith: "lol", caseSensitive: false)
        let expectedQueryResult = "{\"Title\":{\"$options\":\"i\",\"$regex\":\"^lol\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_regexEndsWithCaseInsensitive(){
        let query = EverliveQuery()
        query.filter("Title", endsWith: "lol", caseSensitive: false)
        let expectedQueryResult = "{\"Title\":{\"$options\":\"i\",\"$regex\":\"lol$\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_regexContains(){
        let query = EverliveQuery()
        query.filter("Title", contains: "lol", caseSensitive: true)
        let expectedQueryResult = "{\"Title\":{\"$regex\":\"lol\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testSingle_regexContainsCaseInsensitive(){
        let query = EverliveQuery()
        query.filter("Title", contains: "lol", caseSensitive: false)
        let expectedQueryResult = "{\"Title\":{\"$options\":\"i\",\"$regex\":\"lol\"}}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_gtAndlt(){
        let query = EverliveQuery()
        query.filter("Likes", lessThan: 30, orEqual: false).filter("Likes", greaterThan: 10, orEqual: false).and()
        let expectedQueryResult = "{\"$and\":[{\"Likes\":{\"$lt\":30}},{\"Likes\":{\"$gt\":10}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_eqAndgt(){
        let query = EverliveQuery()
        query.filter("Title", equalTo: "Game of Thrones").filter("Likes", greaterThan: 30, orEqual: false).and()
        let expectedQueryResult = "{\"$and\":[{\"Title\":{\"$eq\":\"Game of Thrones\"}},{\"Likes\":{\"$gt\":30}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_eqAndlte(){
        let query = EverliveQuery()
        query.filter("Title", equalTo: "Game of Thrones").filter("Likes", lessThan: 30, orEqual: true).and()
        let expectedQueryResult = "{\"$and\":[{\"Title\":{\"$eq\":\"Game of Thrones\"}},{\"Likes\":{\"$lte\":30}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_neAndlte(){
        let query = EverliveQuery()
        query.filter("Title", notEqualTo: "Game of Thrones").filter("Likes", lessThan: 30, orEqual: true).and()
        let expectedQueryResult = "{\"$and\":[{\"Title\":{\"$ne\":\"Game of Thrones\"}},{\"Likes\":{\"$lte\":30}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_gtOrlt(){
        let query = EverliveQuery()
        query.filter("Likes", lessThan: 20, orEqual: false).filter("Likes", greaterThan: 40, orEqual: false).or()
        let expectedQueryResult = "{\"$or\":[{\"Likes\":{\"$lt\":20}},{\"Likes\":{\"$gt\":40}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_eqOrgt(){
        let query = EverliveQuery()
        query.filter("Title", equalTo: "Game of Thrones").filter("Likes", greaterThan: 30, orEqual: false).or()
        let expectedQueryResult = "{\"$or\":[{\"Title\":{\"$eq\":\"Game of Thrones\"}},{\"Likes\":{\"$gt\":30}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_eqOrlte(){
        let query = EverliveQuery()
        query.filter("Title", equalTo: "Game of Thrones").filter("Likes", lessThan: 30, orEqual: true).or()
        let expectedQueryResult = "{\"$or\":[{\"Title\":{\"$eq\":\"Game of Thrones\"}},{\"Likes\":{\"$lte\":30}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_neOrlte(){
        let query = EverliveQuery()
        query.filter("Title", notEqualTo: "Game of Thrones").filter("Likes", lessThan: 30, orEqual: true).or()
        let expectedQueryResult = "{\"$or\":[{\"Title\":{\"$ne\":\"Game of Thrones\"}},{\"Likes\":{\"$lte\":30}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testMultiple_eqAndgtAndlte(){
        let query = EverliveQuery()
        query.filter("Title", equalTo: "Game of Thrones").filter("Likes", lessThan: 30, orEqual: true).filter("Likes", greaterThan: 10, orEqual: false).and()
        let expectedQueryResult = "{\"$and\":[{\"Title\":{\"$eq\":\"Game of Thrones\"}},{\"Likes\":{\"$lte\":30}},{\"Likes\":{\"$gt\":10}}]}"
        let actualResult = query.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testCompound_1(){
        let query = EverliveQuery()
        query.filter("Likes", lessThan: 40, orEqual: false).filter("Likes", greaterThan: 20, orEqual: false).and()
        let query2 = EverliveQuery()
        query2.filter("Title", startsWith: "lol", caseSensitive: false)
        let compoundQuery = EverliveCompoundQuery()
        compoundQuery.and([query2, query])
        let expectedQueryResult = "{\"$and\":[{\"Title\":{\"$options\":\"i\",\"$regex\":\"^lol\"}},{\"$and\":[{\"Likes\":{\"$lt\":40}},{\"Likes\":{\"$gt\":20}}]}]}"
        let actualResult = compoundQuery.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
    func testCompound_2(){
        let query = EverliveQuery()
        query.filter("Likes", lessThan: 40, orEqual: false).filter("Likes", greaterThan: 20, orEqual: false).and()
        let query2 = EverliveQuery()
        query2.filter("Title", contains: "lol", caseSensitive: true)
        let compoundQuery = EverliveCompoundQuery()
        compoundQuery.or([query2, query])
        let expectedQueryResult = "{\"$or\":[{\"Title\":{\"$regex\":\"lol\"}},{\"$and\":[{\"Likes\":{\"$lt\":40}},{\"Likes\":{\"$gt\":20}}]}]}"
        let actualResult = compoundQuery.getJson()
        XCTAssertTrue(actualResult == expectedQueryResult, "Expected \(expectedQueryResult) to equal \(actualResult)")
    }
    
}
