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
//#-code-completion(identifier, show, smiley, sad, heart, arrow_left, arrow_right, arrow_left_right, full, dot, small_rect, large_rect, double_row, tick, rock, scissors, well, flash, wave)

func waitForButton() {
  mini.sleep(/*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/)
  while io.button(.A).isPressed {
    mini.sleep(10)
  }
}

func forever() {
  display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
  waitForButton()
  display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
  waitForButton()
  display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
  waitForButton()
}

//#-hidden-code
playgroundEpilogue( BookProgramProjectRockPaperScissors.assessment )
//#-end-hidden-code
