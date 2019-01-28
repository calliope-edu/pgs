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

//#-hidden-code
func waitForButtonA() {}
func waitForPin() -> UInt16 { return random(1...3) }
//#-end-hidden-code

func showColor(pin: UInt16) {
    if pin == 0 {
        rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    }
    if pin == 1 {
        rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    }
    if pin == 2 {
        rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    }
    if pin == 3 {
        rgb.on(color: /*#-editable-code*/.<#T##miniColor##miniColor#>/*#-end-editable-code*/)
    }
}

func correct() {
    display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
}

func wrong() {
    display.show(image: /*#-editable-code*/.<#T##miniImage##miniImage#>/*#-end-editable-code*/)
}

func forever() {
    display.show(image: .arrow_left)
    waitForButtonA()
    let pin1 = random(0...3)
    let pin2 = random(0...3)
    let pin3 = random(0...3)
    let pin4 = random(0...3)
    
    showColor(pin: pin1)
    mini.sleep(200)
    rgb.off()
    mini.sleep(200)
    
    showColor(pin: pin2)
    mini.sleep(200)
    rgb.off()
    mini.sleep(200)
    
    showColor(pin: pin3)
    mini.sleep(200)
    rgb.off()
    mini.sleep(200)
    
    display.show(text: "?")
    
    if waitForPin() == pin1 {
        if waitForPin() == pin2 {
            if waitForPin() == pin3 {
                correct()
            } else {
                wrong()
            }
        } else {
            wrong()
        }
    } else {
        wrong()
    }
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( BookProgramCommandCombination.assessment )
//#-end-hidden-code
