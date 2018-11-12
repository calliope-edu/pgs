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

func onShake() {
    let r = random(/*#-editable-code*/<#T##nummer##UInt#>/*#-end-editable-code*/.../*#-editable-code*/<#T##nummer##UInt#>/*#-end-editable-code*/)
    
    sound.on(note: /*#-editable-code*/.<#T##miniSound##miniSound#>/*#-end-editable-code*/)
    mini.sleep(/*#-editable-code*/<#T##nummer##UInt#>/*#-end-editable-code*/)
    sound.off()
    
    display.show(number: r)
}

//#-hidden-code
//#-editable-code Tap to write your code
//#-end-editable-code
//#-end-hidden-code

//#-hidden-code
playgroundEpilogue( assessment() )
//#-end-hidden-code
