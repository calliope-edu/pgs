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
    for i in /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/.../*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/ {
        //#-hidden-code
        let i = UInt16(i)
        //#-end-hidden-code
        display.show(number: i)
        mini.sleep(/*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/)
    }
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( assessment() )
//#-end-hidden-code
