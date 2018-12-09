//
//  CalliopeBLETest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 08.12.18.
//

import XCTest
@testable import Book_Sources

class CalliopeBLEDiscoveryTest: XCTestCase {

	var discoveryExpectation = XCTestExpectation()
	var connectionExpectation = XCTestExpectation()
	let discoverer = CalliopeBLEDiscovery()
	var calliope : CalliopeBLEDevice? = nil

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testStartCalliopeDiscovery() {
		discoverer.updateBlock = fulfillDiscovery
		discoverer.startCalliopeDiscovery()
		wait(for: [discoveryExpectation], timeout: TimeInterval(30))
	}

	func fulfillDiscovery() {
		if discoverer.state == .discovered && !discoverer.discoveredCalliopes.isEmpty {
			discoveryExpectation.fulfill()
		}
	}

    func testConnectToCalliope() {
		discoverer.updateBlock = updateDiscovery
		discoverer.startCalliopeDiscovery()
		wait(for: [connectionExpectation], timeout: TimeInterval(30))
	}

	func updateDiscovery() {
		print(discoverer.state)
		if discoverer.state == .discovered {
			if let discoveredCalliope = discoverer.discoveredCalliopes.first?.value, calliope == nil {
				discoveredCalliope.updateBlock = updateConnection
				calliope = discoveredCalliope
				discoverer.connectToCalliope(discoveredCalliope)
			}
		}
	}

	func updateConnection() {
		if let calliope = calliope, calliope.state == .connected {
			connectionExpectation.fulfill()
		}
	}

    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
