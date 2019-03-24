//
//  ApiCalls.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 28.01.19.
//

import Foundation

public enum ApiCommand {
	//outputs
	case rgbOn(color: miniColor)
	case rgbOff()

	case displayClear()
	case displayShowGrid(grid: [UInt8])
	case displayShowImage(image: miniImage)
	case displayShowText(text: String)

	case soundOff()
	case soundOnNote(note: miniSound)
	case soundOnFreq(freq: UInt16)

	//other controls
	case sleep(time: UInt16)
	case registerCallbacks()
}

public enum ApiRequest {
	case requestButtonState(button: buttonType)
	case requestPinState(pin: UInt16)
	case requestNoise()
	case requestTemperature()
	case requestBrightness()
	case requestDisplay()
}

public enum ApiResponse {
	case respondButtonState(isPressed: Bool)
	case respondPinState(isPressed: Bool)
	case respondNoise(level: UInt16)
	case respondTemperature(degrees: Int16)
	case respondBrightness(level: UInt16)
	case respondDisplay(grid: [UInt8])

	//empty response
	case finished()
}

public enum ApiCallback {
	//callbacks/inputs
	case buttonA()
	case buttonB()
	case buttonAB()
	case buttonALongPress()
	case buttonBLongPress()
	case buttonABLongPress()

	case pin(pin: UInt16)

	case shake()
	case clap()

	//internally handled
	case start()
	case forever()
}
