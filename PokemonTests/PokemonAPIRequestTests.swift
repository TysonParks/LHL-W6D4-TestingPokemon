//
//  PokemonAPIRequestTests.swift
//  PokemonTests
//
//  Created by Tyson Parks on 3/22/18.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import XCTest
@testable import Pokemon

class MockNetworker: NetworkerType {
    
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // do nothing for now
    }
    
}

class PokemonAPIRequestTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_jsonObjectFromData_GivenEmptyData_ShouldThrowAnError() {
        let pokemonRequest = PokemonAPIRequest(networker: MockNetworker())
        let data = Data()
        XCTAssertThrowsError(try pokemonRequest.jsonObject(fromData: data))
    }
    
}
