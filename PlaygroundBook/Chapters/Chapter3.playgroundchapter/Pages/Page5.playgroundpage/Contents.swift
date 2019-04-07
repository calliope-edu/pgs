//:#localized(key: "cc.calliope.miniplaygroundbook.Inputs.IssuingCommands")

//#-hidden-code
import Foundation
import PlaygroundSupport
//#-end-hidden-code

//#-hidden-code
playgroundPrologue()
//#-end-hidden-code

//#-code-completion(everything, hide)
func start() {
    let name: String = "/*#-editable-code*/<#T##string##String#>/*#-end-editable-code*/"
    display.show(text: name)
	
    let age: UInt16 = /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/
    display.show(number: age)
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( BookProgramCommandVariables.assessment )
//#-end-hidden-code
