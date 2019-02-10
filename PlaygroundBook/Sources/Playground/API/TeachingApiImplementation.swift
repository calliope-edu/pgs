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

	private var rgbState: miniColor = .black

	private var soundFreq: UInt16 = 0

	private var buttonAState: CalliopeBLEDevice.ButtonPressAction = .Up
	private var buttonBState: CalliopeBLEDevice.ButtonPressAction = .Up

	private func resetVars() {
		resetRgbState()
		resetSoundFreq()
		resetButtonState()
	}

	private func resetRgbState() {
		rgbState = .black
	}

	private func resetSoundFreq() {
		soundFreq = 0
	}

	private func resetButtonState() {
		buttonAState = .Up
		buttonBState = .Up
	}

	private let displayOffState = [[false, false, false, false, false],
								   [false, false, false, false, false],
								   [false, false, false, false, false],
								   [false, false, false, false, false],
								   [false, false, false, false, false]]

	func handleApiCall(_ apiCall: ApiCall, calliope: CalliopeBLEDevice?) {
		//TODO: working so far is button notifications, button state requests, sleep, forever, start, led matrix calls, temperature request.
		//TODO: done AB/A/B besser unterscheiden,
		//TODO: 1. to do: rgb led, pins, shake callback, sound api,
		//TODO: 2. erweitern mit Position/Beschleunigungsapi
		//FIXME: 3. brightness request: schwierig
		//FIXME: raus: micro (clap callback, noise request)

		//respond with a message back (either with value or just as a kind of "return" call)

		let response: ApiCall
		switch apiCall {
		case .registerCallbacks():
			registerCallbacks(calliope)
			response = .finished()
		case .rgbOn(let color):
			rgbState = color
			//TODO: send to calliope
			response = .finished()
		case .rgbOff:
			resetRgbState()
			//TODO: send to calliope
			response = .finished()
		case .displayClear:
			calliope?.ledMatrixState = displayOffState
			response = .finished()
		case .displayShowGrid(let grid):
			calliope?.ledMatrixState = interpretGrid(grid)
			response = .finished()
		case .displayShowImage(let image):
			calliope?.ledMatrixState = interpretGrid(image.grid)
			response = .finished()
		case .displayShowText(let text):
			//TODO: display state?
			calliope?.displayLedText(text)
			response = .finished()
		case .soundOff:
			resetSoundFreq()
			//TODO: send to calliope
			response = .finished()
		case .soundOnNote(let note):
			soundFreq = 0 //TODO: note to frequency
			//TODO: send to calliope
			response = .finished()
		case .soundOnFreq(let freq):
			soundFreq = freq
			//TODO: send to calliope
			response = .finished()
		case .requestButtonState(let button):
			response = .respondButtonState(isPressed: buttonPressState(button, calliope) == true)
		case .requestPinState(let pin):
			response = .respondPinState(isPressed: false)
		case .requestNoise:
			response = .respondNoise(level: 42)
		case .requestTemperature:
			response = .respondTemperature(degrees: Int16(calliope?.temperature ?? 42))
		case .requestBrightness:
			response = .respondBrightness(level: 42)
		case .requestDisplay():
			response = .respondDisplay(grid: encodeMatrix(calliope?.ledMatrixState))
		default:
			if case .sleep(_) = apiCall {
			} else {
				LogNotify.log("cannot handle this api call")
			}
			response = .finished()
		}

		let t: Double
		if case .sleep(let time) = apiCall {
			t = Double(time)
		} else {
			t = 0.0
		}

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + t) {
			self.send(apiCall: response)
		}
	}

	func interpretGrid(_ grid: [UInt8]) -> [[Bool]] {
		return (0..<5).map { row in (0..<5).map { column in grid[row * 5 + column] == 1 } }
	}

	func encodeMatrix(_ matrix: [[Bool]]?) -> [UInt8] {
		guard let matrix = matrix else { return encodeNonoptionalMatrix(displayOffState) }
		return encodeNonoptionalMatrix(matrix)
	}

	func encodeNonoptionalMatrix(_ matrix: [[Bool]]) -> [UInt8] {
		return matrix.flatMap { row in row.map { on in on ? 1 : 0 } }
	}

	func registerCallbacks(_ calliope: CalliopeBLEDevice?) {
		guard let calliope = calliope else { return }

		calliope.buttonAActionNotification = { action in
			guard let action = action else { return }
			self.buttonApiNotification(action, .A)
		}
		calliope.buttonBActionNotification = { action in
			guard let action = action else { return }
			self.buttonApiNotification(action, .B)
		}
		//TODO: other callbacks to calliope
	}

	private func buttonPressState(_ button: buttonType, _ calliope: CalliopeBLEDevice?) -> Bool {
		if button == .A {
			let buttonState = buttonAState
			return buttonState == .Down || buttonState == .Long
		} else if button == .B {
			let buttonState = buttonBState
			return buttonState == .Down || buttonState == .Long
		} else {
			let buttonState1 = buttonAState
			let buttonState2 = buttonBState
			let buttonPressed1 = buttonState1 == .Down || buttonState1 == .Long
			let buttonPressed2 = buttonState2 == .Down || buttonState2 == .Long
			return buttonPressed1 && buttonPressed2
		}
	}


	private enum ButtonState: CustomStringConvertible {
		var description: String {
			switch self {
			case .L:
				return "L"
			case .N:
				return "N"
			case .D:
				return "D"
			case .R:
				return "R"
			}
		}

		case N, D, L, R
	}
	var indep = false

	private var state: (ButtonState, ButtonState) = (.N, .N) {
		didSet {
			evaluateStateChange(oldValue)
		}
	}

	/// Sends the appropriate call according to button action.
	/// The normal press notifications are sent when the button is released
	/// Long press notifications are sent as soon as the button is pushed down long enough
	///
	/// - Parameters:
	///   - action: The button press action reported by the notification
	///   - thisButton: The button which emitted the action (.A or .B, never .AB)
	private func buttonApiNotification(_ action: CalliopeBLEDevice.ButtonPressAction, _ thisButton: buttonType) {

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


	private func evaluateStateChange(_ oldValue: (TeachingApiImplementation.ButtonState, TeachingApiImplementation.ButtonState)) {
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

	func send(apiCall: ApiCall) {
		LogNotify.log("sendig \(apiCall) to page")
		let data = apiCall.data
		let message: PlaygroundValue = .dictionary([PlaygroundValueKeys.apiCallKey: .data(data)])
		self.send(message)
	}

}
