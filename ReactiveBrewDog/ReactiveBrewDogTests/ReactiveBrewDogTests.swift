//
//  ReactiveBrewDogTests.swift
//  ReactiveBrewDogTests
//
//  Created by Tom Seymour on 12/8/17.
//  Copyright © 2017 Tom Seymour. All rights reserved.
//

import XCTest
import ReactiveSwift
import Result
@testable import ReactiveBrewDog

class ReactiveBrewDogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBeerRequestManager() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Download Beers")
        
        let beerRequestManager = BeerRequestManagerFactory.getInstance(type: .offline)
        
        let signalProducer = beerRequestManager.fetchMoreBeer().on { beers in
            XCTAssertTrue(beers.count == 80, "No beers found")
            expectation.fulfill()
        }
        
        signalProducer.start()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testBeerListViewModel() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Download Beers")
        
        let viewModel = BeerListViewModel()
        
        viewModel.beerUpdateSignal.observeValues { _ in
            XCTAssertTrue(viewModel.itemsInSection(0) == 80, "No beers found")
            let ip = IndexPath(item: 79, section: 0)
            XCTAssertTrue(viewModel.isLastIndex(ip) == true, "Is Not Last Index")
            expectation.fulfill()
        }
        viewModel.fetchMoreBeer()
        
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testGameEngine() {
        let testBeer = Beer(name: "Carling", id: 501, tagline: "String", firstBrewed: "String", beerDescription: "String", imageURLString: "String", abv: 12.5, ibu: 50)
        
        let gameEngine = BeerGameEngine(beer: testBeer)
        
        XCTAssertTrue(gameEngine.isCorrectIBU(guess: 56) == false)
        XCTAssertTrue(gameEngine.isCorrectIBU(guess: 52) == true)
        XCTAssertTrue(gameEngine.isCorrectIBU(guess: 46) == true)
        
    }
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
