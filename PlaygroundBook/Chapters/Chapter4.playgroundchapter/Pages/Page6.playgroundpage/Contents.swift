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
//#-code-completion(identifier, show, smiley, sad, heart, arrow_left, arrow_right, arrow_left_right, full, dot, small_rect, large_rect, double_row, tick, rock, scissors, well, flash, wave)

func forever() {

  let temperature = io.temperature

  if temperature < /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/ {
    rgb.on(color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
  } else if temperature < /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/ {
    rgb.on(color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
  } else {
    rgb.on(color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
  }
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( assessment() )
//#-end-hidden-code
