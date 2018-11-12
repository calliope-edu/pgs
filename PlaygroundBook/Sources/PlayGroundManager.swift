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
        page.needsIndefiniteExecution = true
        
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
        let _data: PlaygroundValue = .data(data)
        
        proxy.send(_data)
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

//FIXME: is this needed?

    //On live view connection closed
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        // Kill user process if LiveView process closed.
        //PlaygroundPage.current.finishExecution()
        //NSLog("remoteLiveViewProxyConnectionClosed")
        //LogNotify.log("remoteLiveViewProxyConnectionClosed")
    }
    
    //Receive message from live view
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
//        if case let .string(msg) = message {
//            //NSLog("remoteLiveViewProxy... \(msg)")
//            //LogNotify.log("remoteLiveViewProxy: \(msg)")
//        }
        //NSLog("remoteLiveViewProxy...")
        //LogNotify.log("remoteLiveViewProxy")
        
        //PlaygroundPage.current.assessmentStatus = .pass(message: "Booooo")
        PlaygroundPage.current.finishExecution()
    }
}
