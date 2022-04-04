//
//  FeedDateFormatterTests.swift
//  CarsTests
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import XCTest
@testable import Cars

final class FeedDateFormatterTests: XCTestCase {

    private enum Constants {
        static let oneThousandNineHundredNinetyNineYearUnixtime: TimeInterval = 915148800
        static let twoThousandYearUnixtime: TimeInterval = 946684800
    }

    func testCurrentYear24Hours() {
        // arrange
        let currentDate = Date(timeIntervalSince1970: Constants.twoThousandYearUnixtime)
        let currentLocale = Locale(identifier: "en-GB")
        let sut = FeedDateFormatter(currentDate: currentDate, currentLocale: currentLocale)
        let date = Date(timeIntervalSince1970: Constants.twoThousandYearUnixtime)

        // act
        _ = sut.string(from: date)

        // assert
        XCTAssertEqual(sut.dateFormat, "d MMMM, H:mm")
    }

    func testCurrentYear12Hours() {
        // arrange
        let currentDate = Date(timeIntervalSince1970: Constants.twoThousandYearUnixtime)
        let currentLocale = Locale(identifier: "en-US")
        let sut = FeedDateFormatter(currentDate: currentDate, currentLocale: currentLocale)
        let date = Date(timeIntervalSince1970: Constants.twoThousandYearUnixtime)

        // act
        _ = sut.string(from: date)

        // assert
        XCTAssertEqual(sut.dateFormat, "d MMMM, h:mm a")
    }

    func testOldYear24Hours() {
        // arrange
        let currentDate = Date(timeIntervalSince1970: Constants.oneThousandNineHundredNinetyNineYearUnixtime)
        let currentLocale = Locale(identifier: "en-GB")
        let sut = FeedDateFormatter(currentDate: currentDate, currentLocale: currentLocale)
        let date = Date(timeIntervalSince1970: Constants.twoThousandYearUnixtime)

        // act
        _ = sut.string(from: date)

        // assert
        XCTAssertEqual(sut.dateFormat, "d MMMM y, H:mm")
    }

    func testOldYear12Hours() {
        // arrange
        let currentDate = Date(timeIntervalSince1970: Constants.oneThousandNineHundredNinetyNineYearUnixtime)
        let currentLocale = Locale(identifier: "en-US")
        let sut = FeedDateFormatter(currentDate: currentDate, currentLocale: currentLocale)
        let date = Date(timeIntervalSince1970: Constants.twoThousandYearUnixtime)

        // act
        _ = sut.string(from: date)

        // assert
        XCTAssertEqual(sut.dateFormat, "d MMMM y, h:mm a")
    }
}
