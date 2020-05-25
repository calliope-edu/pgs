import Foundation

final class Extractor : CustomStringConvertible {
    
    private var code_inputs:[String] = []
    
    @discardableResult init(_ text: String, completion: (_ report: [String]) -> Void) {
        code_inputs = findUserCodeInputs(from: text)
        completion(code_inputs)
    }
    
    var description: String {
        return code_inputs.description
    }
    
    //TODO: https://stackoverflow.com/questions/32851698/line-number-aware-scanning-with-nsscanner
    
    private func findUserCodeInputs(from input: String) -> [String] {
        var inputs: [String] = []
        let newlineCharacterSet = CharacterSet.newlines
        let ignoreCharactersSet = CharacterSet(charactersIn: "\"").union(newlineCharacterSet)
        let scanner = Scanner(string: input)
        
        while !scanner.isAtEnd {
            scanner.scanUpTo("/*#-editable-code", into: nil)
            var text: NSString? = nil
            scanner.scanUpTo("*/", into: nil)
            if (scanner.scanLocation < input.count) {
                scanner.scanLocation += 2
            }
            scanner.scanUpTo("/*#-end-editable-code", into: &text)
            
            if text != nil {
                var str:String = String(text!)
                str = str.trimmingCharacters(in: ignoreCharactersSet)
                inputs.append(str)
            }
        }
        
        return inputs
    }
}

