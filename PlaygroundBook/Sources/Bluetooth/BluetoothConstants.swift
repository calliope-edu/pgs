//
//  BluetoothConstants.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 23.02.19.
//

import Foundation

struct BluetoothConstants {
	static let discoveryTimeout = 20.0
	static let connectTimeout = 5.0
	static let readTimeout = 2.0
	static let writeTimeout = 2.0

	//TODO: set this to 0 as soon as coupling is not necessary any more
	static let couplingDelay = 2.0

	static let restartDuration = 4.0

	static let lastConnectedKey = "cc.calliope.latestDeviceKey"
	static let lastConnectedNameKey = "name"
	static let lastConnectedUUIDKey = "uuidString"
	static let deviceNames = ["calliope", "micro:bit"]
}
