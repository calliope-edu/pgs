import Foundation
import PlaygroundSupport
import PlaygroundBluetooth

//MARK: class that handels communication from and to liveview and thus runs page

final class PlayGroundManager : PlaygroundRemoteLiveViewProxyDelegate {
    
    public static let shared = PlayGroundManager()

    private init() {
        // LogNotify.log("PlayGroundManager init")
    } //This prevents others from using the default '()' initializer for this class.
    
    public func setup() {
        // LogNotify.log("PlayGroundManager setup")
        
        let page = PlaygroundPage.current

        page.needsIndefiniteExecution = false
        
        let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
        proxy?.delegate = self
    }
    
    private var assessment: AssessmentBlock?
    
    public func registerAssessment(_ block: @escaping AssessmentBlock) {
        self.assessment = block
    }
    
    public func run() {
        // LogNotify.log("PlayGroundManager run")
        Extractor(PlaygroundPage.current.text) { [weak self] (report) in
            LogNotify.log("inside extractor report: \(report)")
            
            guard let assessment = self?.assessment else {
                self?.closeLiveViewProxy("no assessment...?")
                return
            }
            
            // LogNotify.log("inside extractor assessment: \(String(describing:assessment))")
            
            let result_tuple = assessment(report)
            
            // LogNotify.log("assessment: \(String(describing: result_tuple))")
            
            //let result = result_tuple.result ?? .fail(hints: ["no result default... result"], solution: nil)
            if let result = result_tuple.result {
                self?.showStatus(result)
            }
            self?.sendProgram(result_tuple.program)
        }
    }
    
    private func sendProgram(_ program: Program?) {
        
        guard let prog = program else {
            closeLiveViewProxy("no prog... return")
            return
        }
        
        proxyLog("program: \(prog)")
        let build_result:ProgramBuildResult = prog.build()
        
        let encoder = PropertyListEncoder()
        guard let data = try? encoder.encode(build_result) else {
            closeLiveViewProxy("Failed to encode BuildResult...")
            return
        }
        guard let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
            closeLiveViewProxy("No PlaygroundRemoteLiveViewProxy found...")
            return
        }

		proxy.send(PlaygroundValue.dictionary([PlaygroundValueKeys.programKey: .data(data)]))
    }
    
    private func showStatus(_ result: AssessmentResults) {
        LogNotify.log("program: \(String(describing: result))")
        PlaygroundPage.current.assessmentStatus = result
    }
    
    private func closeLiveViewProxy(_ msg: String) {
        LogNotify.log("closeLiveViewProxy: \(msg)")
        //PlaygroundPage.current.assessmentStatus = .fail(hints: ["total fail... result"], solution: nil)
        PlaygroundPage.current.finishExecution()
    }
    
    //TODO: is this needed? or was it just for logging-view
    private func proxyLog(_ msg: String) {
        let page = PlaygroundPage.current
        if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
            let message: PlaygroundValue = .string(msg)
            proxy.send(message)
        }
    }


	//MARK: receiving messages from live view

    //On live view connection closed
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        // Kill user process if LiveView process closed.
        PlaygroundPage.current.finishExecution()
    }
    
    //Receive message from live view
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        if case let .string(msg) = message {
            LogNotify.log("remoteLiveViewProxy: \(msg)")
		} else if case let .dictionary(dict) = message {
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

	public func startForever() {
		PlaygroundPage.current.needsIndefiniteExecution = true
		foreverCall()
	}

	private func foreverCall() {
		myCalliope?.forever()
		//execute again with delay of 0.1s (otherwise it might turn ipad into an oven)
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
			self.foreverCall()
		}
	}

	private let messagingQueue = DispatchQueue(label: "messaging queue", qos: .userInitiated, attributes: .concurrent)
	private let semaphore = DispatchSemaphore(value: 1)
	private let deparallelizationGroup = DispatchGroup()
	private var apiResponse: ApiResponse?

	public func sendCommand(apiCall: ApiCommand) {
		semaphore.wait()
		sendPlaygroundMessage(.dictionary([PlaygroundValueKeys.apiCommandKey: .data(apiCall.data)]))
		let value: Bool? = extractApiResponseValue()
		if value == nil || value! == false {
			LogNotify.log("api command \(apiCall) failed")
		}
		semaphore.signal()
	}

	public func sendRequest<T>(apiCall: ApiRequest) -> T? {
		semaphore.wait()
		sendPlaygroundMessage(.dictionary([PlaygroundValueKeys.apiRequestKey: .data(apiCall.data)]))
		let value: T? = extractApiResponseValue()
		semaphore.signal()
		return value
	}

	private func sendPlaygroundMessage(_ message: PlaygroundValue) {
		let page = PlaygroundPage.current
		guard let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy else {
			LogNotify.log("cannot send \(message) because there is current page")
			return
		}
		asyncAndWait(on: messagingQueue) {
			self.deparallelizationGroup.enter()
			proxy.send(message)
			self.deparallelizationGroup.wait()
		}
	}

	private func extractApiResponseValue<T>() -> T? {
		guard let apiResponse = self.apiResponse else { return nil }
		self.apiResponse = nil

		switch apiResponse {
		case .respondTemperature(let degrees):
			return degrees as? T
		case .respondNoise(let level):
			return level as? T
		case .respondPinState(let isPressed):
			return isPressed as? T
		case .respondButtonState(let isPressed):
			return isPressed as? T
		case .respondBrightness(let level):
			return level as? T
		case .respondDisplay(let grid):
			return grid as? T
		case .finished():
			return true as? T
		}
	}

	public func processApiCallback(_ apiCall: ApiCallback) {
		LogNotify.log("playground page received api notification \(apiCall)")
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
			case .shake():
				myCalliope?.onShake()
			case .start:
				myCalliope?.start()
			case .forever:
				myCalliope?.forever()
			}
		}
	}

	public func processApiResponse(apiCall: ApiResponse) {
		apiResponse = apiCall
		deparallelizationGroup.leave()
	}
}
