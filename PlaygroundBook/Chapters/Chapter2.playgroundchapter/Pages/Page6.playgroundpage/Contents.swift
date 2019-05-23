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
//#-code-completion(identifier, show, c´, d´, e´, f´, g´, a´, h´, c´´)
//#-code-completion(identifier, show, smiley, sad, heart, arrow_left, arrow_right, arrow_left_right, full, dot, small_rect, large_rect, double_row, tick, rock, scissors, well, flash, wave)
//#-code-completion(identifier, show, red, green, blue, yellow, black, darkGray, lightGray, white, cyan, magenta, orange, purple)

func onButtonA() {
    display.show(grid: [
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    ])
    rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
}

func onButtonB() {
    display.show(grid: [
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    ])
    rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
}

func onButtonAB() {
    display.show(grid: [
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/, /*#-editable-code*/1/*#-end-editable-code*/,
    ])
    rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
}

func onShake() {
    sound.on(note: /*#-editable-code*/.<#T##miniSound##miniSound#>/*#-end-editable-code*/)
}

func onPin(pin: UInt16) {
	display.show(number: pin)
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( BookProgramInputCombination.assessment )
//#-end-hidden-code
