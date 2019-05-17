import Foundation
import UIKit

public struct Result<T> {
    private(set) var value: T
    private(set) var success: Bool
    
    public init(_ value: T, _ success: Bool) {
        self.value = value
        self.success = success
    }
}

public struct Worker<T> {
    public typealias ResultType = Result<T>
    private let work: ( @escaping (ResultType) -> ()) -> ()
    
    public init(resolve: @escaping ( @escaping (ResultType) -> ()) -> ()) {
        self.work = resolve
    }
    
    public func done(_ completion: @escaping (_ value: T, _ success: Bool) -> ()) {
        self.work() { result in
            completion(result.value, result.success)
        }
    }
}

func async(_ queue: DispatchQueue = DispatchQueue.global(qos: .background), _ block: @escaping (() throws -> Void)) -> Worker<String> {
    return Worker { resolve in
        
        queue.async {
            do {
                try block()
                DispatchQueue.main.async {
                    resolve(Result("Work is done.", true))
                }
            } catch {
                DispatchQueue.main.async {
                    resolve(Result("Error: \(error)", false))
                }
            }
        }
        
    }
}

func delay(queue: DispatchQueue = DispatchQueue.main, time: Double, _ block: @escaping (() -> Void)) {
    let when = DispatchTime.now() + time
    queue.asyncAfter(deadline: when) {
        block()
    }
}
