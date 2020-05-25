//
//  Runtime.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 03.02.19.
//

import Foundation
import PlaygroundSupport

//MARK: api for programs that need to compile code

public func playgroundPrologue() {
	PlayGroundManager.shared.setup()
}

//MARK: api for programs that are executed on the ipad

///calliope for receiving signals (e.g. when button is pressed, temperature changed, ...)
public var myCalliope: Calliope? {
	didSet {
		PlaygroundPage.current.needsIndefiniteExecution = true
		//register for callbacks
		PlayGroundManager.shared.sendCommand(apiCall: .setUp())
		//execute start once
		myCalliope?.start()
		//start the calls to "forever" after a slight delay
		PlayGroundManager.shared.foreverCall()
	}
}

public var stopForever = false

public func sendCommand(apiCall: ApiCommand) {
	PlayGroundManager.shared.sendCommand(apiCall: apiCall)
}

public func sendRequest<T>(apiCall: ApiRequest) -> T? {
	return PlayGroundManager.shared.sendRequest(apiCall: apiCall)
}
