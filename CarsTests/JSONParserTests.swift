//
//  JSONParserTests.swift
//  CarsTests
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import XCTest
@testable import Cars

final class JSONParserTests: XCTestCase {

    private enum Constants {
        static let fileName = "response"
        static let fileExtension = "json"
    }

    private var sut: JSONParser!

    override func setUp() {
        super.setUp()

        sut = .init()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testResponse() throws {
        // arrange
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: Constants.fileName, withExtension: Constants.fileExtension),
              let data = try Data(contentsOf: url) as Data? else {
            return
        }

        // act
        let response = try sut.decode(data: data, responseModel: Response<Article>.self)

        // assert
        XCTAssertEqual(response.status, "success")
        XCTAssertEqual(response.items.count, 9)

        let first = try XCTUnwrap(response.items.first)

        XCTAssertEqual(first.identifier, 119302)
        XCTAssertEqual(first.title, "Q7 - Greatness starts, when you don't stop.")
        XCTAssertEqual(first.publishDate, .init(timeIntervalSince1970: 1527257580))
        XCTAssertEqual(first.ingress, "The Audi Q7 is the result of an ambitious idea: never cease to improve.")
        XCTAssertEqual(first.imageURL, .init(string: "https://www.apphusetreach.no/sites/default/files/audi_q7.jpg"))
        XCTAssertEqual(first.creationDate, .init(timeIntervalSince1970: 1511968425))
        XCTAssertEqual(first.lastModifiedDate, .init(timeIntervalSince1970: 1534311497))

        XCTAssertTrue(first.tags.isEmpty)

        let firstContent = try XCTUnwrap(first.items.first)
        XCTAssertEqual(firstContent.type, .text)
        XCTAssertEqual(firstContent.title, "Q7")
        XCTAssertEqual(firstContent.text, """
        The Audi Q7 is masculine, yet exudes lightness. Inside, it offers comfort at the highest level. With even \
        more space for your imagination. The 3.0 TDI engine accelerates this powerhouse as a five-seater starting \
        at an impressive 6.3 seconds from 0 to 100 km/h.
        """)
    }
}
