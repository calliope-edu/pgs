import Foundation
import PlaygroundSupport
import PlaygroundBluetooth

//MARK: class that handels communication from and to liveview and thus runs page

final class PlayGroundManager : PlaygroundRemoteLiveViewProxyDelegate {
    
    public static let shared = PlayGroundManager()

	private init() {  //This prevents others from using the default '()' initializer for this class.
        LogNotify.log("PlayGroundManager initialized")
    }
    
    public func setup() {
        LogNotify.log("PlayGroundManager setup")
        
        let page = PlaygroundPage.current

        page.needsIndefiniteExecution = false
        
        let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
        proxy?.delegate = self
    }
    
    private func closeLiveViewProxy(_ msg: String) {
        LogNotify.log("closeLiveViewProxy: \(msg)")
        //PlaygroundPage.current.assessmentStatus = .fail(hints: ["total fail... result"], solution: nil)
        PlaygroundPage.current.finishExecution()
    }


	//MARK: receiving messages from live view

    //On live view connection closed
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        // Kill user process if LiveView process closed.
        PlaygroundPage.current.finishExecution()
    }
    
    //Receive message from live view
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
		LogNotify.log("page received \(message)")
        if case let .dictionary(dict) = message {
			if case let .data(callData)? = dict[PlaygroundValueKeys.apiResponseKey],
				let apiCall = ApiResponse(data: callData) {
				processApiResponse(apiCall: apiCall)
			} else if case let .data(callData)? = dict[PlaygroundValueKeys.apiCallbackKey],
				let apiCall = ApiCallback(data: callData) {
				processApiCallback(apiCall)
			} else {
				LogNotify.log("received unknown dictionary from liveView: \(dict)")
			}
		} else {
			LogNotify.log("received unknown message from liveView: \(message)")
		}
    }


	//MARK: API interface

	public func foreverCall() {
		guard !stopForever else { return } //never execute forever again.
		myCalliope?.forever()
		//execute again with delay of 0.02s (otherwise it might turn ipad into an oven if no sleep time is set)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.02) {
			self.foreverCall()
		}
	}

	private let messagingQueue = DispatchQueue(label: "messaging queue", qos: .userInitiated, attributes: .concurrent)
	private let semaphore = DispatchSemaphore(value: 1)
	private let deparallelizationGroup = DispatchGroup()
	private var apiResponse: ApiResponse?
    
    public func sendCommand(apiCall: ApiCommand) {
        applySemaphore(semaphore) {
            sendRequestOrCommandAndWait(.dictionary([PlaygroundValueKeys.apiCommandKey: .data(apiCall.data)]))
            let value: Bool? = extractApiResponseValue()
            if value == nil || value! == false {
                LogNotify.log("api command \(apiCall) failed")
            }
        }
    }
    
    public func sendRequest<T>(apiCall: ApiRequest) -> T? {
		return applySemaphore(semaphore) {
			sendRequestOrCommandAndWait(.dictionary([PlaygroundValueKeys.apiRequestKey: .data(apiCall.data)]))
			let value: T? = extractApiResponseValue()
			return value
		}
	}

	private func sendRequestOrCommandAndWait(_ message: PlaygroundValue) {
		LogNotify.log("sending \(message) to liveview")
		let page = PlaygroundPage.current
		guard let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy else {
			LogNotify.log("cannot send \(message) because there is no liveview")
			return
		}
		waitForAsyncExecution(on: messagingQueue) {
			self.deparallelizationGroup.enter()
			proxy.send(message)
			self.deparallelizationGroup.wait()
		}
	}

	public func processApiResponse(apiCall: ApiResponse) {
		apiResponse = apiCall
		deparallelizationGroup.leave()
	}

	private func sendPlaygroundMessage(_ message: PlaygroundValue) {
		//NO LOGNOTIFY HERE (leads to endless cycle)
		let page = PlaygroundPage.current
		guard let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy else {
			LogNotify.log("cannot send \(message) because there is no liveview")
			return
		}
		proxy.send(message)
	}

	private func extractApiResponseValue<T>() -> T? {
		guard let apiResponse = self.apiResponse else { return nil }
		self.apiResponse = nil
		LogNotify.log("page received response \(apiResponse)")

		switch apiResponse {
		case .respondTemperature(let degrees):
			return degrees as? T
		case .respondNoise(let level):
			return level as? T
		case .respondPinState(let buttonState):
			return buttonState as? T
		case .respondButtonState(let buttonState):
			return buttonState as? T
		case .respondBrightness(let level):
			return level as? T
		case .respondDisplay(let grid):
			return grid as? T
		case .finished():
			return true as? T
		}
	}

	public func processApiCallback(_ apiCall: ApiCallback) {
		LogNotify.log("page received api notification \(apiCall)")
		DispatchQueue.main.async {
			switch apiCall {
			case .buttonA():
				myCalliope?.onButtonA()
			case .buttonB():
				myCalliope?.onButtonB()
			case .buttonAB():
				myCalliope?.onButtonAB()
			case .buttonALongPress():
				myCalliope?.onButtonALongPress()
			case .buttonBLongPress():
				myCalliope?.onButtonBLongPress()
			case .buttonABLongPress():
				myCalliope?.onButtonABLongPress()
			case .pin(let pin):
				myCalliope?.onPin(pin: pin)
			case .pinLongTouch(let pin):
				myCalliope?.onPinLongPress(pin: pin)
			case .shake():
				myCalliope?.onShake()
			case .start:
				myCalliope?.start()
			case .forever:
				myCalliope?.forever()
			}
		}
	}

	//MARK: debug messages

	public func sendNotification(_ notification: Notification) {
		guard let notificationInfo = (notification.userInfo?.mapValues { text in PlaygroundValue.string(text as! String) }) as? [String: PlaygroundValue] else { return }
		self.sendPlaygroundMessage(.dictionary([DebugConstants.logNotifyName : .dictionary(notificationInfo)]))
	}
}
