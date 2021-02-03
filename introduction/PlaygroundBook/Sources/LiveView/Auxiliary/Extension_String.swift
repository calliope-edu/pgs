import Foundation

extension String {
    
    func hasPrefixes(_ prefixes:[String]) -> Bool {
        for prefix in prefixes {
            if self.hasPrefix(prefix) {
                return true
            }
        }
        return false
    }
    
    public func removePrefix(_ prefix: String) -> String {
        var str = self
        if str.hasPrefix(prefix) {
            str = String(str.dropFirst())
        }
        return str
    }
}
