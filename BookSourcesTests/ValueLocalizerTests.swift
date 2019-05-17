//
//  ValueLocalizerTests.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 18.11.18.
//

import XCTest
@testable import Book_Sources

class ValueLocalizerTests: XCTestCase {

	let localizer = ValueLocalizer.current

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocalizeValue() {
		//NEEDS IPAD TEMPERATURE UNIT SET TO FAHRENHEIT
		XCTAssertEqual(localizer.localizeTemperature(unlocalized: 20.0), 68.0, accuracy: 0.5)
    }

	func testDelocalizeValue() {
		//NEEDS IPAD TEMPERATURE UNIT SET TO FAHRENHEIT
		XCTAssertEqual(localizer.delocalizeTemperature(localized: 68.0), 20.0, accuracy: 0.5)
	}

	func testLocalizedValueString() {
		//NEEDS IPAD TEMPERATURE UNIT SET TO FAHRENHEIT
		XCTAssertEqual(localizer.localizedTemperatureString(unlocalizedValue: 20.0), "68°F")
	}

	/*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
