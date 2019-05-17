//
//  ProgrammableCalliopeTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 13.01.19.
//

import XCTest
@testable import Book_Sources

/// this test needs a calliope with program and notify service enabled
/// and the corresponding configuration of the required services in CalliopeBLEDevice
class ProgrammableCalliopeTest: XCTestCase {

	let calliopeTest = CalliopeBLEDeviceTest<ProgrammableCalliope>()

	public lazy var programUploadExpectation = XCTestExpectation(description: "upload program to \(calliopeTest.calliopeNameInMode5)")
	public lazy var notificationExpectation = XCTestExpectation(description: "temperature value read")

	let programLEDNotificationExpectation = XCTestExpectation()
	let programThermometerNotificationExpectation = XCTestExpectation()
	let programRGBNotificationExpectation = XCTestExpectation()
	let programNoiseNotificationExpectation = XCTestExpectation()
	let programBrightnessNotificationExpectation = XCTestExpectation()
	var notificationTokens: [NotificationToken] = []

	fileprivate func waitForNotification(_ type: DashboardItemType, _ fulfilled: @escaping () -> () = {}) {
		self.notificationTokens.append(
			NotificationCenter.default.observe(name: UIView_DashboardItem.ValueUpdateNotification, using: { (notification) in
				DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now(), execute: {
					if notification.userInfo?["type"] as? DashboardItemType == type {
						fulfilled()
					}
				})
			}))
	}

	func testLedNotification() {
		notificationTest(BookProgramOutputString(), DashboardItemType.Display) { self.programLEDNotificationExpectation.fulfill() }
		wait(for: [programLEDNotificationExpectation], timeout: TimeInterval(30))
    }

	func testRGBNotification() {
		notificationTest(BookProgramOutputRGB(), DashboardItemType.RGB) { self.programRGBNotificationExpectation.fulfill() }
		wait(for: [programRGBNotificationExpectation], timeout: TimeInterval(30))
	}

	func testSoundNotification() {
		notificationTest(BookProgramOutputSound(), DashboardItemType.Sound) { self.programNoiseNotificationExpectation.fulfill() }
		wait(for: [programNoiseNotificationExpectation], timeout: TimeInterval(30))
	}

	func testThermometerNotification() {
		notificationTest(BookProgramProjectThermometer(), DashboardItemType.Thermometer) { self.programThermometerNotificationExpectation.fulfill() }
		wait(for: [programThermometerNotificationExpectation], timeout: TimeInterval(30))
	}

	func testBrightnessNotification() {
		notificationTest(BookProgramProjectTheremin(), DashboardItemType.Brightness){ self.programBrightnessNotificationExpectation.fulfill() }
		wait(for: [programBrightnessNotificationExpectation], timeout: TimeInterval(30))
	}

	func testProgramUpload() {
		//NEEDS ONE CALLIOPE SET TO MODE 5. SET NAME AT BEGINNING OF THE CLASS ACCORDINGLY!
		self.calliopeTest.discoveryTest.discover {
			self.calliopeTest.connectToCalliopeInMode5() {
				self.uploadProgram() {
					self.programUploadExpectation.fulfill()
				}
			}
		}
		wait(for: [programUploadExpectation], timeout: TimeInterval(30))
	}

	func testNotifications() {
		//NEEDS ONE CALLIOPE SET TO MODE 5. SET NAME AT BEGINNING OF THE CLASS ACCORDINGLY!
		self.calliopeTest.discoveryTest.discover {
			self.calliopeTest.connectToCalliopeInMode5() {
				self.uploadProgram() {
					self.programUploadExpectation.fulfill()
				}
			}
		}
		NotificationCenter.default.addObserver(forName: UIView_DashboardItem.ValueUpdateNotification, object: nil, queue: nil) { notification in
			if notification.userInfo?["type"] as? DashboardItemType == DashboardItemType.Thermometer {
				self.notificationExpectation.fulfill()
			}
		}
		wait(for: [notificationExpectation, programUploadExpectation], timeout: TimeInterval(50))
	}



	private func notificationTest(_ program: Program, _ type: DashboardItemType, _ fulfilled: @escaping () -> () = {}) {
		self.calliopeTest.discoveryTest.discover {
			self.calliopeTest.connectToCalliopeInMode5() {
				self.uploadProgram(program) {
					self.waitForNotification(type) { fulfilled() }
				}
			}
		}
	}

	private func uploadProgram(_ program: Program = BookProgramProjectThermometer(), fulfilled: @escaping () -> () = {}) {
		do {
			NSLog("upload program \(type(of:program))")
			try calliopeTest.calliopeInMode5!.upload(program: program.build())
			fulfilled()
		} catch {
			NSLog("Failed to upload program \(type(of:program))")
		}
	}
}
