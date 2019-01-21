//
//  BluetoothApiTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 13.01.19.
//

import XCTest
@testable import Book_Sources

/// for this test, we need a calliope with all used bluetooth services enabled,
/// as well as these services in the required services array of CalliopeBLEDevice
class BluetoothApiTest: XCTestCase {

	let calliopeTest = CalliopeBLEDeviceTest()
	let ledTestExpectation = XCTestExpectation()
	let temperatureUpdateExpectation = XCTestExpectation()
	let magnetometerUpdateExpectation = XCTestExpectation()
	let accelerometerUpdateExpectation = XCTestExpectation()

	func testLEDWriteOnly() {
		bluetoothApiTest { calliope in
			//show diagonal stripe
			let setState = [
				[true, false, false, false, false],
				[false, true, false, false, false],
				[false, false, true, false, false],
				[false, false, false, false, false],
				[false, false, false, false, false]
			]
			calliope.ledMatrixState = setState
			self.ledTestExpectation.fulfill()
		}
		wait(for: [ledTestExpectation], timeout: 30)
	}

    func testLedService() {
		bluetoothApiTest { calliope in
			//show diagonal stripe
			let setState = [
				[true, false, false, false, false],
				[false, true, false, false, false],
				[false, false, true, false, false],
				[false, false, false, false, false],
				[false, false, false, false, false]
			]
			calliope.ledMatrixState = setState
			let readLedState = calliope.ledMatrixState
			XCTAssertEqual(readLedState, setState,
					  "led should have the state that was just set")
			self.ledTestExpectation.fulfill()
		}
		wait(for: [ledTestExpectation], timeout: 30)
    }

	func testTemperatureService() {
		bluetoothApiTest { calliope in
			let periodSetter = { (i: UInt16) in calliope.temperatureUpdateFrequency = i }
			let periodGetter = { return calliope.temperatureUpdateFrequency }
			let valueGetter = { return calliope.temperature }
			let updateSetter = { (updateBlock: @escaping (UInt8?) -> ()) in calliope.temperatureNotification = updateBlock }
			self.testServiceWithFrequency(periodSetter, periodGetter, valueGetter, updateSetter, self.temperatureUpdateExpectation)
		}
		wait(for: [temperatureUpdateExpectation], timeout: 30)
	}

	func testAccelerometerService() {
		bluetoothApiTest { calliope in
			let periodSetter = { (i: UInt16) in calliope.accelerometerUpdateFrequency = i }
			let periodGetter = { return calliope.accelerometerUpdateFrequency }
			let valueGetter = { return calliope.accelerometerValue }
			let updateSetter = { (updateBlock: @escaping ((Int16, Int16, Int16)?) -> ()) in calliope.accelerometerNotification = updateBlock }
			self.testServiceWithFrequency(periodSetter, periodGetter, valueGetter, updateSetter, self.accelerometerUpdateExpectation)
		}
		wait(for: [accelerometerUpdateExpectation], timeout: 30)
	}

	func testMagnetometerService() {
		bluetoothApiTest { calliope in
			let periodSetter = { (i: UInt16) in calliope.magnetometerUpdateFrequency = i }
			let periodGetter = { return calliope.magnetometerUpdateFrequency }
			let valueGetter = { return calliope.magnetometerValue }
			let updateSetter = { (updateBlock: @escaping ((Int16, Int16, Int16)?) -> ()) in calliope.magnetometerNotification = updateBlock }
			self.testServiceWithFrequency(periodSetter, periodGetter, valueGetter, updateSetter, self.magnetometerUpdateExpectation)
		}
		wait(for: [magnetometerUpdateExpectation], timeout: 30)
	}

	func testServiceWithFrequency<T>(_ periodSetter: (UInt16) -> (), _ periodGetter: () -> UInt16?, _ valueGetter: () -> T, _ updateSetter: (@escaping (T) -> ()) -> (), _ expectation: XCTestExpectation) {
		var updateTime = -1.0
		let updateFrequency = UInt16(640)
		periodSetter(updateFrequency)
		let readUpdateFrequency = periodGetter()
		XCTAssertNotNil(readUpdateFrequency, "should be able to read a value, but was nil")
		guard let readFrequency = readUpdateFrequency else { return }
		XCTAssert(readFrequency == updateFrequency,
				  "led should have the state that was just set, but is \(readUpdateFrequency!) instead of \(updateFrequency)")
		let value = valueGetter()
		XCTAssertNotNil(value)
		updateSetter { value in
			if updateTime < 0 {
				updateTime = Date().timeIntervalSince1970
			} else {
				let time = Date().timeIntervalSince1970
				XCTAssertEqual(updateTime, time - 640.0, accuracy: 10.0, "value should be updated every 640ms")
				expectation.fulfill()
			}
		}
	}

	private func bluetoothApiTest(_ apiUsage: @escaping (CalliopeBLEDevice) -> ()) {
		self.calliopeTest.discoveryTest.discover {
			self.calliopeTest.connectToCalliopeInMode5() {
				//TODO: not sure if this is just needed for the playground or always
				DispatchQueue(label: "backgroundBluetooth", qos: .userInteractive).async {
					apiUsage(self.calliopeTest.calliopeInMode5!)
				}
			}
		}
	}
}
