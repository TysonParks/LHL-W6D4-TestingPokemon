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
    
    func test_jsonObjectFromData_GivenInvalidJsonData_ShouldThrowAnError() {
        let networker = MockNetworker()
        let pokemonRequest = PokemonAPIRequest(networker: networker)
        
        let invalidJSON = ""
        let data = invalidJSON.data(using: .utf8)!
        XCTAssertThrowsError(try pokemonRequest.jsonObject(fromData: data))
    }
    
    func test_jsonObjectFromData_GivenJSONObjectData_ShouldReturnJSONObject() {
        let networker = MockNetworker()
        let pokemonRequest = PokemonAPIRequest(networker: networker)
        
        let validJSON = "{\"\":\"\"}"
        let data = validJSON.data(using: .utf8)!
        guard let result = try! pokemonRequest.jsonObject(fromData: data) as? [String: String] else {
            XCTFail("Invalid JSON returned")
            return
        }
        XCTAssertEqual(result, ["": ""])
    }
    
    func test_buildURL_GivenStringEndpoint_ShouldReturnValidURL() {
        let networker = MockNetworker()
        let pokemonRequest = PokemonAPIRequest(networker: networker)
        
        let validURL = URL(string: "https://pokeapi.co/api/v2/pokemon")
        let endpoint = "pokemon"
        guard let result = try! pokemonRequest.buildURL(endpoint: endpoint) as? URL else {
            XCTFail("Invalid URL returned")
            return
        }
        XCTAssertEqual(result, validURL)
    }
    
    func test_PokemonFromJSON_GivenValidJSON_ShouldReturnPokemon() {
        let networker = MockNetworker()
        let pokemonRequest = PokemonAPIRequest(networker: networker)
        
        
        let path = Bundle.main.path(forResource: "Pokemon", ofType: "json")
        let jsonData = try! NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonObject = try! pokemonRequest.jsonObject(fromData: jsonData as Data)
        guard let result = try! pokemonRequest.pokemons(fromJSON: jsonObject) as? [Pokemon] else {
            XCTFail("Invalid Pokemon returned")
            return
        }
//        XCTAssertEqual(result, validURL)
    }

}
