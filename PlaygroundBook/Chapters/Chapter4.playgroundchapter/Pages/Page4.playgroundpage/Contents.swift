//:#localized(key: "cc.calliope.miniplaygroundbook.Inputs.IssuingCommands")

//#-hidden-code
import Foundation
import PlaygroundSupport
//#-end-hidden-code

//#-hidden-code
playgroundPrologue()
//#-end-hidden-code

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, .)
//#-code-completion(identifier, show, red, green, blue, yellow, black, darkGray, lightGray, white, cyan, magenta, orange, purple)

func waitForClap() {
    let threshold:UInt16 = /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/

    while io.noise < threshold {
      mini.sleep(10)
    }

    while io.noise >= threshold {
      mini.sleep(10)
    }
}

func forever() {
    waitForClap()
    rgb.on(color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    waitForClap()
    rgb.off()
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( BookProgramProjectClap.assessment )
//#-end-hidden-code
