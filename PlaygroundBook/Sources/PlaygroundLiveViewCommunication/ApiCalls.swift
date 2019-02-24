//
//  ApiCalls.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 28.01.19.
//

import Foundation

public enum ApiCall {

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


	//outputs
	/*case rgbOn(color: miniColor)
	case rgbOff()*/

	case displayClear()
	case displayShowGrid(grid: [UInt8])
	case displayShowImage(image: miniImage)
	case displayShowText(text: String)

	/*case soundOff()
	case soundOnNote(note: miniSound)
	case soundOnFreq(freq: UInt16)*/

	case requestButtonState(button: buttonType)
	case respondButtonState(isPressed: Bool)

	case requestPinState(pin: UInt16)
	case respondPinState(isPressed: Bool)

	case requestNoise()
	case respondNoise(level: UInt16)

	case requestTemperature()
	case respondTemperature(degrees: Int16)

	case requestBrightness()
	case respondBrightness(level: UInt16)

	case requestDisplay()
	case respondDisplay(grid: [UInt8])

	//other controls
	case sleep(time: UInt16)
	case finished()
	case registerCallbacks()
	//internally handled
	case start()
	case forever()
}
