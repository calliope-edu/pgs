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
//#-code-completion(identifier, show, C, D, E, F, G, A, H, C5)
//#-code-completion(identifier, show, red, green, blue, yellow, black, darkGray, lightGray, white, cyan, magenta, orange, purple)

func note(pin: UInt,
          note: miniSound,
          color: miniColor) {
    if io.pin(pin).isPressed {
      rgb.on(color:color)
      sound.on(note:note)
      while io.pin(pin).isPressed {
        mini.sleep(10)
      }
      sound.off()
      rgb.off()
    }
}

func forever() {
  note(pin:0, note:/*#-editable-code*/.<#T##miniSound##miniSound#>/*#-end-editable-code*/, color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
  note(pin:1, note:/*#-editable-code*/.<#T##miniSound##miniSound#>/*#-end-editable-code*/, color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
  note(pin:2, note:/*#-editable-code*/.<#T##miniSound##miniSound#>/*#-end-editable-code*/, color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
  note(pin:3, note:/*#-editable-code*/.<#T##miniSound##miniSound#>/*#-end-editable-code*/, color:/*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( BookProgramProjectPiano.assessment )
//#-end-hidden-code
