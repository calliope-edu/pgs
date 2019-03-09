//
//  Runtime.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 03.02.19.
//

import Foundation
import PlaygroundSupport

//MARK: api for programs that need to compile code

public typealias AssessmentTuple = (result: AssessmentResults?, program: Program?)
public typealias AssessmentBlock = ([String]) -> AssessmentTuple
public typealias AssessmentResults = PlaygroundPage.AssessmentStatus

public func playgroundPrologue() {
	PlayGroundManager.shared.setup()
}

public func playgroundEpilogue(_ block: AssessmentBlock? = nil) {
	if let block = block {
		PlayGroundManager.shared.registerAssessment(block)
	}
	PlayGroundManager.shared.run()
}

//MARK: api for programs that are executed on the ipad

///calliope for receiving signals (e.g. when button is pressed, temperature changed, ...)
public var myCalliope: Calliope? {
	didSet {
		//register for callbacks
		PlayGroundManager.shared.sendCommand(apiCall: .registerCallbacks())
		//execute start once
		myCalliope?.start()
		//start the calls to "forever" after a slight delay
		PlayGroundManager.shared.startForever()
	}
}

public func sendCommand(apiCall: ApiCommand) {
	PlayGroundManager.shared.sendCommand(apiCall: apiCall)
}

public func sendRequest<T>(apiCall: ApiRequest) -> T? {
	return PlayGroundManager.shared.sendRequest(apiCall: apiCall)
}
