//
//  CalliopeBLEDeviceTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 09.12.18.
//

import XCTest
@testable import Book_Sources

class CalliopeBLEDeviceTest<C: CalliopeBLEDevice>: XCTestCase {

	public let calliopeNameInMode5 = "povig"
	public let calliopeNameNotInMode5 = "zavig"

	public lazy var notMode5DiscoveryExpectation = XCTestExpectation(description: "connect to \(calliopeNameNotInMode5) (not in mode 5)")
	public lazy var mode5DiscoveryExpectation = XCTestExpectation(description: "connect to \(calliopeNameInMode5) (is in mode 5)")

	let discoveryTest = CalliopeBLEDiscoveryTest<C>()

	var calliopeNotInMode5 : C?
	var calliopeInMode5 : C?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPairingModeDiscovery() {
		//NEEDS ONE CALLIOPE SET TO MODE 5 AND ONE NOT, BUT PAIRABLE. SET NAMES AT BEGINNING OF THE CLASS ACCORDINGLY!
		discoveryTest.discover {
			self.connectToCalliopeNotInMode5() {
				self.notMode5DiscoveryExpectation.fulfill()
			}
			self.connectToCalliopeInMode5() {
				self.mode5DiscoveryExpectation.fulfill()
			}
		}
		wait(for: [mode5DiscoveryExpectation, notMode5DiscoveryExpectation], timeout: TimeInterval(30))
	}

	func connectToCalliopeNotInMode5(fulfilled: @escaping () -> () = {}) {
		calliopeNotInMode5 = discoveryTest.discoverer.discoveredCalliopes[self.calliopeNameNotInMode5]
		if let calliopeNotInMode5 = self.calliopeNotInMode5 {
			calliopeNotInMode5.updateBlock = {
				//take over update notifications
				if calliopeNotInMode5.state == .notPlaygroundReady {
					calliopeNotInMode5.updateBlock = {}
					fulfilled()
				}
			}
			discoveryTest.connect(calliopeNotInMode5)
		}
	}

	func connectToCalliopeInMode5(fulfilled: @escaping () -> () = {}) {
		calliopeInMode5 = discoveryTest.discoverer.discoveredCalliopes[self.calliopeNameInMode5]
		if let calliopeInMode5 = self.calliopeInMode5 {
			calliopeInMode5.updateBlock = {
				//take over update notifications
				if calliopeInMode5.state == .playgroundReady {
					calliopeInMode5.updateBlock = {}
					fulfilled()
				}
			}
			discoveryTest.connect(calliopeInMode5)
		}
	}

}
