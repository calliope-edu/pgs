//
//  NotificationTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 13.01.19.
//

import XCTest
@testable import Book_Sources

/// this test needs a calliope with program and notify service enabled
/// and the corresponding configuration of the required services in CalliopeBLEDevice
class NotificationTest: XCTestCase {

	let calliopeTest = CalliopeBLEDeviceTest()
	let programLEDNotificationExpectation = XCTestExpectation()
	let programThermometerNotificationExpectation = XCTestExpectation()
	let programRGBNotificationExpectation = XCTestExpectation()
	let programNoiseNotificationExpectation = XCTestExpectation()
	let programBrightnessNotificationExpectation = XCTestExpectation()
	var notificationTokens: [NotificationToken] = []

	fileprivate func waitForNotification(_ type: DashboardItemType, _ fulfilled: @escaping () -> () = {}) {
		self.notificationTokens.append(
			NotificationCenter.default.observe(name: UIView_DashboardItem.Ping, using: { (notification) in
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
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

	private func notificationTest(_ program: Program, _ type: DashboardItemType, _ fulfilled: @escaping () -> () = {}) {
		self.calliopeTest.discoveryTest.discover {
			self.calliopeTest.connectToCalliopeInMode5() {
				self.uploadProgram(program) {
					self.waitForNotification(type) { fulfilled() }
				}
			}
		}
	}

	private func uploadProgram(_ program: Program, fulfilled: @escaping () -> () = {}) {
		do {
			NSLog("upload program \(type(of:program))")
			try calliopeTest.calliopeInMode5!.upload(program: program.build())
			fulfilled()
		} catch {
			NSLog("Failed to upload program \(type(of:program))")
		}
	}
}
