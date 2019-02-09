//
//  CalliopeBLETest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 08.12.18.
//

import XCTest
@testable import Book_Sources

class CalliopeBLEDiscoveryTest: XCTestCase {

	public let discoveryExpectation = XCTestExpectation()
	public let connectionExpectation = XCTestExpectation()
	public let discoverer = CalliopeBLEDiscovery()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testStartCalliopeDiscovery() {
		discover() {
			self.discoveryExpectation.fulfill()
		}
		wait(for: [discoveryExpectation], timeout: TimeInterval(30))
	}

	func testConnectToCalliope() {
		discover {
			self.connect(self.discoverer.discoveredCalliopes.first!.value) {
				self.connectionExpectation.fulfill()
			}
		}
		wait(for: [connectionExpectation], timeout: TimeInterval(30))
	}

	func discover(fulfilled: @escaping () -> () = {}) {
		discoverer.updateBlock = {
			if self.discoverer.state == .discoveredAll && !self.discoverer.discoveredCalliopes.isEmpty {
				fulfilled()
			}
		}
		discoverer.startCalliopeDiscovery()
		DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + 6.0) {
			self.discoverer.stopCalliopeDiscovery()
		}
	}

	func connect(_ calliope: CalliopeBLEDevice, fulfilled: @escaping () -> () = {}) {
		discoverer.updateBlock = {
			if self.discoverer.state == .connected {
				fulfilled()
			}
		}
		discoverer.connectToCalliope(calliope)
	}

    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
