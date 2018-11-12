//:#localized(key: "commands.ifelse")

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
    if r == /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/ {
        display.show(text: "/*#-editable-code*/<#T##string##String#>/*#-end-editable-code*/")
    } else {
        display.show(text: "/*#-editable-code*/<#T##string##String#>/*#-end-editable-code*/")
    }
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( assessment() )
//#-end-hidden-code
