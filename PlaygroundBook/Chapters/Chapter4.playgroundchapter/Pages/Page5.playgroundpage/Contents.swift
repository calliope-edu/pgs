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
	let brightness = io.brightness
	if brightness > 0 {
		let frequency: UInt16 = /*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/
			+ (/*#-editable-code*/<#T##number##UInt#>/*#-end-editable-code*/ * brightness)
		sound.on(frequency: frequency)
	} else {
		sound.off()
	}
	sleep(100)
}

//#-hidden-code
playgroundEpilogue( BookProgramProjectTheremin.assessment )
//#-end-hidden-code
