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
	let ledTestExpectation = XCTestExpectation(description: "led service")
	let temperatureUpdateExpectation = XCTestExpectation(description: "temperature service")
	let magnetometerUpdateExpectation = XCTestExpectation(description: "magnetometer service")
	let accelerometerUpdateExpectation = XCTestExpectation(description: "accelerometer service")

	func testLedWriteOnly() {
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
			let updateSetter = { (updateBlock: @escaping (Int8?) -> ()) in calliope.temperatureNotification = updateBlock }
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

	func testServiceWithFrequency<T>(_ periodSetter: (UInt16) -> (), _ periodGetter: () -> UInt16?, _ valueGetter: () -> T, _ updateSetter: @escaping (@escaping (T) -> ()) -> (), _ expectation: XCTestExpectation, period: UInt16 = UInt16(1000)) {

		let updateFrequency = period

		periodSetter(updateFrequency)
		let readUpdateFrequency = periodGetter()
		XCTAssertNotNil(readUpdateFrequency, "should be able to read a value, but was nil")
		guard let readFrequency = readUpdateFrequency else { return }
		XCTAssertEqual(readFrequency, updateFrequency, "service should have the notification frequency that was just set")
		let value = valueGetter()
		XCTAssertNotNil(value)
		var updateTime = -1.0
		updateSetter { value in
			if updateTime < 0 {
				updateTime = Date().timeIntervalSince1970
			} else {
				let time = Date().timeIntervalSince1970
				XCTAssertEqual(updateTime, time - (Double(updateFrequency) / 1000.0),
							   accuracy: (Double(updateFrequency) / 5000.0), "value should be updated every \(updateFrequency)ms (actual diff. \((time - updateTime) * 1000.0)ms")
				updateSetter { _ in return }
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
