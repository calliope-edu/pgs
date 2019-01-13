//
//  CalliopeBLEDeviceTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 09.12.18.
//

import XCTest
@testable import Book_Sources

class CalliopeBLEDeviceTest: XCTestCase {

	public let calliopeNameInMode5 = "zavig"
	public let calliopeNameNotInMode5 = "povig"

	public lazy var notMode5DiscoveryExpectation = XCTestExpectation(description: "connect to zavig (not in mode 5)")
	public lazy var mode5DiscoveryExpectation = XCTestExpectation(description: "connect to povig (is in mode 5)")

	public lazy var programUploadExpectation = XCTestExpectation(description: "upload program to povig")

	public lazy var notificationExpectation = XCTestExpectation(description: "temperature value read")

	let discoveryTest = CalliopeBLEDiscoveryTest()

	var calliopeNotInMode5 : CalliopeBLEDevice?
	var calliopeInMode5 : CalliopeBLEDevice?

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

	func testProgramUpload() {
		//NEEDS ONE CALLIOPE SET TO MODE 5. SET NAME AT BEGINNING OF THE CLASS ACCORDINGLY!
		discoveryTest.discover {
			self.connectToCalliopeInMode5() {
				self.uploadProgram() {
					self.programUploadExpectation.fulfill()
				}
			}
		}
		wait(for: [programUploadExpectation], timeout: TimeInterval(30))
	}

	func testNotifications() {
		//NEEDS ONE CALLIOPE SET TO MODE 5. SET NAME AT BEGINNING OF THE CLASS ACCORDINGLY!
		discoveryTest.discover {
			self.connectToCalliopeInMode5() {
				self.uploadProgram() {
					self.programUploadExpectation.fulfill()
				}
			}
		}
		NotificationCenter.default.addObserver(forName: UIView_DashboardItem.Ping, object: nil, queue: nil) { notification in
			if notification.userInfo?["type"] as? DashboardItemType == DashboardItemType.Thermometer {
				self.notificationExpectation.fulfill()
			}
		}
		wait(for: [notificationExpectation, programUploadExpectation], timeout: TimeInterval(50))
	}

	func connectToCalliopeNotInMode5(fulfilled: @escaping () -> () = {}) {
		calliopeNotInMode5 = discoveryTest.discoverer.discoveredCalliopes[self.calliopeNameNotInMode5]
		if let calliopeNotInMode5 = self.calliopeNotInMode5 {
			calliopeNotInMode5.updateBlock = {
				//take over update notifications
				if calliopeNotInMode5.state == .notPlaygroundReady {
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
					fulfilled()
				}
			}
			discoveryTest.connect(calliopeInMode5)
		}
	}

	func uploadProgram(fulfilled: @escaping () -> () = {}) {
		let program = BookProgramProjectThermometer()
		do {
			try self.calliopeInMode5!.upload(program: program.build())
			fulfilled()
		} catch {}
	}

    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/

}
