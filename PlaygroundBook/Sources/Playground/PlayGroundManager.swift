import Foundation
import PlaygroundSupport
import PlaygroundBluetooth

//FIXME: class that listens...
//FIXME: no need for singleton...?

public typealias AssessmentTuple = (result: AssessmentResults?, program: Program?)
public typealias AssessmentBlock = ([String]) -> AssessmentTuple
public typealias AssessmentResults = PlaygroundPage.AssessmentStatus

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
        proxy?.delegate = PlayGroundManager.shared // as extension
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

		proxy.send(PlaygroundValue.dictionary(["program": .data(data)]))
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
		} else if case let .dictionary(msg) = message {
			if case let .data(call)? = msg["apiCall"],
				let apiCall = try? PropertyListDecoder().decode(ApiCall.self, from: call) {
				callFromApiInterface(apiCall: apiCall)
			}
		}
    }


	//MARK: sending and receiving API calls

	///calliope for api callbacks (e.g. when button is pressed, temperature changed, ...)
	public var myCalliope: Calliope? {
		didSet {
			//execute start once (if it exists)
			myCalliope?.start?()
			//start the calls to "forever" after a slight delay
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
				self.foreverCall()
			}
		}
	}

	private func foreverCall() {
		guard let foreverFunction = myCalliope?.forever else { return }
		foreverFunction()
		//execute again with delay of 0.1s
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
			self.foreverCall()
		}
	}

	public func sendWithoutResponse(apiCall: ApiCall) {
		guard
			let sent: Bool = send(apiCall: apiCall),
			sent == true
		else {
			LogNotify.log("call to api \(apiCall) failed!")
			return
		}
	}

	private let semaphore = DispatchSemaphore(value: 1)
	private let deparallelizationGroup = DispatchGroup()
	private var apiResponse: ApiCall?

	public func send<T>(apiCall: ApiCall) -> T? {

		semaphore.wait()

		let page = PlaygroundPage.current
		guard
			let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy,
			let data = try? PropertyListEncoder().encode(apiCall)
		else {
			LogNotify.log("no current page or encoding \(apiCall) failed")
			semaphore.signal()
			return nil
		}

		deparallelizationGroup.enter()
		let message: PlaygroundValue = .dictionary(["call": .data(data)])
		proxy.send(message)

		deparallelizationGroup.wait()

		let value: T? = extractApiResponseValue()
		//TODO: return response as T
		semaphore.signal()
		return value
	}

	private func extractApiResponseValue<T>() -> T? {
		guard let apiResponse = apiResponse else { return nil }

		switch apiResponse {
		case .respondTemperature(let degrees):
			return degrees as? T
		case .respondNoise(let level):
			return level as? T
		case .respondPinState(let isPressed):
			return isPressed as? T
		case .respondButtonState(let isPressed):
			return isPressed as? T
		default:
			return nil
		}

	}

	public func callFromApiInterface(apiCall: ApiCall) {
		switch apiCall {
		case .buttonA(), .buttonB(), .buttonAB(), .buttonALongPress()
			, .buttonBLongPress(), .buttonABLongPress(), .pin(_), .shake(), .clap(), .start(), .forever():
			DispatchQueue.main.async {
				self.callObservingCalliope(apiCall: apiCall)
			}
		default:
			callResponse(apiCall: apiCall)
		}
	}

	public func callObservingCalliope(apiCall: ApiCall) {
		switch apiCall {
		case .buttonA():
			myCalliope?.onButtonA?()
		case .buttonB():
			myCalliope?.onButtonB?()
		case .buttonAB():
			myCalliope?.onButtonAB?()
		case .buttonALongPress():
			myCalliope?.onButtonALongPress?()
		case .buttonBLongPress():
			myCalliope?.onButtonBLongPress?()
		case .buttonABLongPress():
			myCalliope?.onButtonABLongPress?()
		case .pin(let pin):
			myCalliope?.onPin?(pin: pin)
		case .shake():
			myCalliope?.onShake?()
		case .clap():
			myCalliope?.onClap?()
		case .start():
			myCalliope?.start?()
		case .forever():
			myCalliope?.forever?()
		default:
			//TODO: sort this out
			return
		}
	}

	public func callResponse(apiCall: ApiCall) {
		apiResponse = apiCall
		deparallelizationGroup.leave()
	}
}
