//
//  CalliopeBLEDeviceTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 09.12.18.
//

import XCTest
@testable import Book_Sources

class CalliopeBLEDeviceTest: XCTestCase {

	public let calliopeNameNotInMode5 = "zavig"
	public let calliopeNameInMode5 = "povig"

	public let notMode5DiscoveryExpectation = XCTestExpectation(description: "discover zavig (not in mode 5)")
	public let mode5DiscoveryExpectation = XCTestExpectation(description: "discover povig (is in mode 5)")

	private var calliopeNotInMode5 : CalliopeBLEDevice?
	private var calliopeInMode5 : CalliopeBLEDevice?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPairingModeDiscovery() {
		let discoveryTest = CalliopeBLEDiscoveryTest()
		discoveryTest.discover {
			self.connectToCalliopeNotInMode5(discoveryTest) {
				self.notMode5DiscoveryExpectation.fulfill()
			}
			self.connectToCalliopeInMode5(discoveryTest) {
				self.mode5DiscoveryExpectation.fulfill()
			}
		}
		wait(for: [mode5DiscoveryExpectation, notMode5DiscoveryExpectation], timeout: TimeInterval(40))
	}

	func connectToCalliopeNotInMode5(_ discoveryTest: CalliopeBLEDiscoveryTest, fulfilled: @escaping () -> ()) {
		calliopeNotInMode5 = discoveryTest.discoverer.discoveredCalliopes[self.calliopeNameNotInMode5]
		if let calliopeNotInMode5 = self.calliopeNotInMode5 {
			discoveryTest.connect(calliopeNotInMode5) {
				calliopeNotInMode5.updateBlock = {
					//take over update notifications
					if calliopeNotInMode5.state == .notPlaygroundReady {
						fulfilled()
					}
				}
			}
		}
	}

	func connectToCalliopeInMode5(_ discoveryTest: CalliopeBLEDiscoveryTest, fulfilled: @escaping () -> ()) {
		calliopeInMode5 = discoveryTest.discoverer.discoveredCalliopes[self.calliopeNameInMode5]
		if let calliopeInMode5 = self.calliopeInMode5 {
			discoveryTest.connect(calliopeInMode5) {
				calliopeInMode5.updateBlock = {
					//take over update notifications
					if calliopeInMode5.state == .playgroundReady {
						fulfilled()
					}
				}
			}
		}
	}

    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
