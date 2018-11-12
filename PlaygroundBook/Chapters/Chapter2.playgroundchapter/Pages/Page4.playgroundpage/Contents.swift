//:#localized(key: "cc.calliope.miniplaygroundbook.Inputs.IssuingCommands")

//#-hidden-code
import Foundation
import PlaygroundSupport
//#-end-hidden-code

//#-hidden-code
playgroundPrologue()
//#-end-hidden-code

//#-code-completion(everything, hide)
func onPin(pin:UInt16) {
    display.show(number:pin)
	//#-code-completion(identifier, show, red, green, blue, yellow, black, darkGray, lightGray, white, cyan, magenta, orange, purple)
	rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)

}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( assessment() )
//#-end-hidden-code
