//:#localized(key: "cc.calliope.miniplaygroundbook.Inputs.IssuingCommands")

//#-hidden-code
import Foundation
import PlaygroundSupport
//#-end-hidden-code

//#-hidden-code
playgroundPrologue()
//#-end-hidden-code

//#-code-completion(everything, hide)
func onShake() {
    let r = random(/*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/.../*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/)
    display.show(number: r)
}

//#-hidden-code
playgroundEpilogue( BookProgramCommandRandom.assessment )
//#-end-hidden-code
