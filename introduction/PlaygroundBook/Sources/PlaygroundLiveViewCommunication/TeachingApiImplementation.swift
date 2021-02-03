//
//  ApiImplementation.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 09.02.19.
//

import UIKit
import PlaygroundSupport

class TeachingApiImplementation: PlaygroundLiveViewMessageHandler {

	static let instance = TeachingApiImplementation()

	private static let scrollingDelay = 100 //TODO: make constant in some config file
    
    public var connectionOpen = false

	//MARK: Variables mirroring calliope state

	private var buttonAState: BLEDataTypes.ButtonPressAction = .Up
	private var buttonBState: BLEDataTypes.ButtonPressAction = .Up

	private var pinState: [UInt8] = [0, 0, 0, 0]

	private var rgbState: (UInt8, UInt8, UInt8) = (0, 0, 0)

	private var soundFreq: UInt16 = 0

	private func resetVars() {
		resetRgbState()
		resetSoundFreq()
		resetButtonState()
		resetPinState()
	}

	private func resetRgbState() {
		rgbState = (0, 0, 0)
	}

	private func resetSoundFreq() {
		soundFreq = 0
	}

	private func resetButtonState() {
		buttonAState = .Up
		buttonBState = .Up
	}

	private func resetPinState() {
		pinState = [0, 0, 0, 0]
	}

	private let displayOffState = [[false, false, false, false, false],
								   [false, false, false, false, false],
								   [false, false, false, false, false],
								   [false, false, false, false, false],
								   [false, false, false, false, false]]

    
    //MARK: responding to playground page
    
    func send(apiCall: ApiResponse) {
        LogNotify.log("sendig \(apiCall) to page")
        let data = apiCall.data
        let message: PlaygroundValue = .dictionary([PlaygroundValueKeys.apiResponseKey: .data(data)])
        if connectionOpen {
            self.send(message)
        }
    }
    
    func send(apiCall: ApiCallback) {
        LogNotify.log("sendig \(apiCall) to page")
        let data = apiCall.data
        let message: PlaygroundValue = .dictionary([PlaygroundValueKeys.apiCallbackKey: .data(data)])
        if connectionOpen {
            self.send(message)
        }
    }
    

	//MARK: handling commandas and requests from playground page

	func handleApiCommand(_ command: ApiCommand, calliope: ApiCalliope?) {
		//DONE: button notifications, button state requests, sleep, forever, start, led matrix calls, temperature request.
		//DONE: AB/A/B besser unterscheiden,
		//DONE: brightness, rgb led

		//FIXME: pins, shake callback
		//FIXME: noise request, sound api

		//TODO: erweitern mit Lage/Beschleunigungsapi

		//respond with a message back (either with value or just as a kind of "return" call)

		var t = 0.0

		switch command {
		case .setUp():
			setUp(calliope)
		case .rgbOnColor(let color):
			//alpha has no effect so far
			let (rf, gf, bf, _) = color.color.components
			let (r, g, b) = (UInt8(rf * 255), UInt8(gf * 255), UInt8(bf * 255))
			rgbState = (r, g, b)
			calliope?.setColor(r: r, g: g, b: b)
		case .rgbOnValues(let r, let g, let b):
			rgbState = (r, g, b)
			calliope?.setColor(r: r, g: g, b: b)
		case .rgbOff:
			resetRgbState()
			calliope?.setColor(r: 0, g: 0, b: 0)
		case .displayClear:
			calliope?.ledMatrixState = displayOffState
		case .displayShowGrid(let grid):
			calliope?.ledMatrixState = convertGrid(grid)
		case .displayShowImage(let image):
			calliope?.ledMatrixState = convertGrid(image.grid)
		case .displayShowText(let text):
			cleanSplitAndPrint(text, calliope)
		case .soundOff:
			resetSoundFreq()
			calliope?.setSound(frequency: 0, duration: 100)
		case .soundOnNote(let note):
			soundFreq = note.rawValue
			calliope?.setSound(frequency: soundFreq)
		case .soundOnFreq(let freq):
			soundFreq = freq
			calliope?.setSound(frequency: freq)
		case .sleep(let time):
            t = Double(time) / 1000
		}

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + t) {
            self.send(apiCall: .finished())
		}
	}

	func handleApiRequest(_ request: ApiRequest, calliope: ApiCalliope?) {

		let response: ApiResponse

		switch request {
		case .requestButtonState(let button):
			response = .respondButtonState(isPressed: buttonPressState(button))
		case .requestPinState(let pin):
			if pin < 4 {
				response = .respondPinState(isPressed: pinState[Int(pin)])
			} else {
				response = .respondPinState(isPressed: 0)
			}
		case .requestNoise:
			let noise = calliope?.noiseLevel
			if let noise = noise {
			response = .respondNoise(level: UInt16(noise))
			} else {
				response = .respondNoise(level: 999)
			}
		case .requestTemperature:
			let temperature = calliope?.temperature
			if let temperature = temperature {
				response = .respondTemperature(degrees: Int16(temperature))
			} else {
				response = .respondTemperature(degrees: 999)
			}
		case .requestBrightness:
			let brightness = calliope?.brightness
			if let brightness = brightness {
				response = .respondBrightness(level: brightness)
			} else {
				response = .respondBrightness(level: 0)
			}
		case .requestDisplay():
			response = .respondDisplay(grid: encodeMatrix(calliope?.ledMatrixState))
		}

		DispatchQueue.main.async {
			self.send(apiCall: response)
		}
	}


	//MARK: helper methods

	func setUp(_ calliope: ApiCalliope?) {
		guard let calliope = calliope else { return }

		//give calliope reliable and swift text scroll speed
		calliope.scrollingDelay = UInt16(TeachingApiImplementation.scrollingDelay)

		//register callbacks for calliope sensors

		// BUTTONS
		calliope.buttonAActionNotification = { action in
			guard let action = action else { return }
			self.buttonApiNotification(action, .A)
		}
		calliope.buttonBActionNotification = { action in
			guard let action = action else { return }
			self.buttonApiNotification(action, .B)
		}

		//TOUCH PINS
		calliope.touchPinNotification = { action in
			guard let (pin, value) = action else { return }
			self.pinTouchNotification(pin, value)
		}

		calliope.gestureNotification = { action in
			guard let gesture = action else { return }
			self.gestureNotification(gesture)
		}

		calliope.temperatureUpdateFrequency = 10000
		calliope.temperatureNotification = {_ in }
		updateBrightness(calliope)
		updateNoise(calliope)
	}

	func updateNoise(_ calliope: ApiCalliope) {
		_ = calliope.noiseLevel
		delay(time: 2) { self.updateNoise(calliope) }
	}

	func updateBrightness(_ calliope: ApiCalliope) {
		_ = calliope.brightness
		delay(time: 10) { self.updateBrightness(calliope) }
	}

	func convertGrid(_ grid: [UInt8]) -> [[Bool]] {
		return (0..<5).map { row in (0..<5).map { column in grid[row * 5 + column] == 1 } }
	}

	func encodeMatrix(_ matrix: [[Bool]]?) -> [UInt8] {
		guard let matrix = matrix else { return encodeNonoptionalMatrix(displayOffState) }
		return encodeNonoptionalMatrix(matrix)
	}

	func encodeNonoptionalMatrix(_ matrix: [[Bool]]) -> [UInt8] {
		return matrix.flatMap { row in row.map { on in on ? 1 : 0 } }
	}

	var stringsPending: [DispatchWorkItem] = []
	let stringOutputQueue = DispatchQueue(label: "StringOutput")

	private func cleanSplitAndPrint(_ text: String, _ calliope: ApiCalliope?) {

		//all string pieces not yet output are overridden
		LogNotify.log("cancelling \(stringsPending.count) pending string outputs")
		for dwi in stringsPending {
			dwi.cancel()
		}
		stringsPending.removeAll()

		let cleanedText = String(text.unicodeScalars.filter({ char in char.isASCII })).components(separatedBy: " ")

		guard cleanedText.count > 0 else { return }

		var stringSizeSoFar = 0
		var nextString = cleanedText[0]
		for text in cleanedText[1...] {
			if nextString.count + text.count + 1 < 20 {
				nextString += " \(text)"
			} else {
				let toPrint = nextString //somehow the string is not captured otherwise oO
				stringsPending.append(
					delay(queue: stringOutputQueue, time: calculateDelay(stringSizeSoFar)) {
						self.chopAndPrint(toPrint, calliope)
					}
				)
				stringSizeSoFar += (nextString.count + 1)
				nextString = text
			}
		}
		stringsPending.append(
			delay(time: calculateDelay(stringSizeSoFar)) {
				self.chopAndPrint(nextString, calliope)
			}
		)
	}

	private func chopAndPrint(_ cleanedText: String, _ calliope: ApiCalliope?) {

		let sliceSize = 20

		//chop up text
		var currentPosition = cleanedText.startIndex
		for i in 0...((cleanedText.count - 1) / sliceSize) {
			let endIndex = ((i+1)*sliceSize < cleanedText.count
				? cleanedText.index(currentPosition, offsetBy: sliceSize)
				: cleanedText.endIndex)
			let substring = String(cleanedText[currentPosition..<endIndex])
			stringsPending.append(
				delay(queue: stringOutputQueue, time: calculateDelay(i * sliceSize)) {
					calliope?.displayLedText(substring)
				}
			)
			currentPosition = endIndex
		}
	}

	private func calculateDelay(_ stringSizeSoFar: Int) -> Double {
		let additionalDelay = 22
		return Double(stringSizeSoFar * 5 * (TeachingApiImplementation.scrollingDelay + additionalDelay)) / 1000.0
	}

	private func buttonPressState(_ button: buttonType) -> UInt8 {
		if button == .A {
			let buttonState = buttonAState
			return buttonState.rawValue
		} else if button == .B {
			let buttonState = buttonBState
			return buttonState.rawValue
		} else {
			let buttonState1 = buttonAState
			let buttonState2 = buttonBState
			if buttonState1 == .Down && buttonState2 == .Down
				|| buttonState1 == .Long && buttonState2 == .Long {
				return buttonState1.rawValue
			} else {
				return 0
			}
		}
	}


	private enum ButtonState {
		case N, D, L, R
	}
	var indep = false

	private var state: (ButtonState, ButtonState) = (.N, .N) {
		didSet { evaluateButtonStateChange(oldValue) }
	}

	/// Sends the appropriate call according to button action.
	/// The normal press notifications are sent when the button is released
	/// Long press notifications are sent as soon as the button is pushed down long enough
	///
	/// - Parameters:
	///   - action: The button press action reported by the notification
	///   - thisButton: The button which emitted the action (.A or .B, never .AB)
	private func buttonApiNotification(_ action: BLEDataTypes.ButtonPressAction, _ thisButton: buttonType) {

		//update states of buttons
		if thisButton == .A {
			buttonAState = action
			switch action {
			case .Up:
				state = (.R, state.1)
			case .Down:
				state = (.D, state.1)
			case .Long:
				state = (.L, state.1)
			}
		} else {
			buttonBState = action
			switch action {
			case .Up:
				state = (state.0, .R)
			case .Down:
				state = (state.0, .D)
			case .Long:
				state = (state.0, .L)
			}
		}
	}


	private func evaluateButtonStateChange(_ oldValue: (TeachingApiImplementation.ButtonState, TeachingApiImplementation.ButtonState)) {
		switch (oldValue, state, indep) {

		case ((.N,.D),(.N, .R), false):
			//on release of B when A never pressed
			send(apiCall: .buttonB())
		case ((.D,.N),(.R,.N), false):
			//on release of A when B never pressed
			send(apiCall: .buttonA())
		case ((.D,.R),(.R,.R), false), ((.R,.D),(.R,.R), false):
			//on release of second button after both were pressed
			send(apiCall: .buttonAB())
		case ((.D,.R),(.L,.R), false):
			//on long press of A (and previous short press of B)
			send(apiCall: .buttonB())
			send(apiCall: .buttonALongPress())
		case ((.D,.N),(.L,.N), false):
			//on long press of A (without previous short press of B)
			send(apiCall: .buttonALongPress())
		case ((.R,.D),(.R,.L), false):
			//on long press of B (and previous short press of A)
			send(apiCall: .buttonA())
			send(apiCall: .buttonBLongPress())
		case ((.N,.D),(.N,.L), false):
			//on long press of B (without previous short press of A)
			send(apiCall: .buttonBLongPress())
		case ((.L,.D),(.L,.L), false), ((.D,.L),(.L,.L), false):
			//on second button long pressed after A or B already long pressed
			send(apiCall: .buttonABLongPress())

		//independent evaluation: whenever a button state changes, notification is emitted
		case ((_, .D), (_, .R), true):
			send(apiCall: .buttonB())
		case ((_, .D), (_, .L), true):
			send(apiCall: .buttonBLongPress())
		case ((.D, _), (.R, _), true):
			send(apiCall: .buttonA())
		case ((.D, _), (.L, _), true):
			send(apiCall: .buttonALongPress())

		//one button notification was released previously, now combination of buttons is irrelevant
		case ((.R,.D), (.D,.D), false),
			 ((.D,.R), (.D,.D), false),
			 ((.R,.L), (.D,.L), false),
			 ((.L,.R), (.L,.D), false),
			 ((.N,.L), (.D,.L), false),
			 ((.L,.N), (.L,.D), false):
			indep = true

		default:
			break
		}

		switch state {
		//all released, go back to initial state
		case (.R, .R), (.N, .R), (.R, .N):
			indep = false
			state = (.N, .N)
		default:
			break
		}
	}

	private func pinTouchNotification(_ pin: UInt8, _ value: BLEDataTypes.ButtonPressAction) {
		pinState[Int(pin)] = value.rawValue
		if (value == .Down) {
			self.send(apiCall: ApiCallback.pin(pin: UInt16(pin)))
		} else if (value == .Long) {
			self.send(apiCall: ApiCallback.pinLongTouch(pin: UInt16(pin)))
		}
	}

	private func gestureNotification(_ gesture: BLEDataTypes.AccelerometerGesture) {
		switch gesture {
		//TODO: add callbacks for other gestures
		case .tiltUp:
			break
		case .tiltDown:
			break
		case .tiltLeft:
			break
		case .tiltRight:
			break
		case .faceUp:
			break
		case .faceDown:
			break
		case .freefall:
			break
		case .acceleration3g:
			break
		case .acceleration6g:
			break
		case .acceleration8g:
			break
		case .shake:
			self.send(apiCall: .shake())
		}
	}
}
