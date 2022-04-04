//
//  FeedViewModelTests.swift
//  CarsTests
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import XCTest
@testable import Cars

final class FeedViewModelTests: XCTestCase {

    private var sut: FeedViewModel!
    private var articlesService: ArticlesServiceSpy!

    override func setUp() {
        super.setUp()

        articlesService = .init()
        sut = .init(articlesService: articlesService)
    }

    override func tearDown() {
        articlesService = nil
        sut = nil

        super.tearDown()
    }

    func testGetPost() {
        // arrange
        let expectation = expectation(description: #function)

        // act
        sut.getPosts() {
            expectation.fulfill()
        }

        // assert
        waitForExpectations(timeout: 5)
        XCTAssertTrue(articlesService.getAllCalled)
    }
}
