//:#localized(key: "cc.calliope.miniplaygroundbook.Inputs.IssuingCommands")

//#-hidden-code
import Foundation
import PlaygroundSupport
//#-end-hidden-code

//#-hidden-code
playgroundPrologue()
//#-end-hidden-code

//#-code-completion(everything, hide)

func forever() {
  let frequency:UInt16 = io.brightness * /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/ + /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/
  sound.on(frequency: frequency)
  sleep(100)
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( assessment() )
//#-end-hidden-code
