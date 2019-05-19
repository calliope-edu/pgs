//
//  LocalizationTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 19.05.19.
//

import XCTest

class LocalizationTest: XCTestCase {

	let localizableStrings = [

		"result.upload.failed",
		"result.upload.missing",
		"result.upload.success",

		"alert.notconnected.title",
		"alert.notconnected.button",
		"ble.name.unknown",

		"page.hint1",
		"page.hint2",
		"page.hint3",
		"page.solution",
		"page.success",

		"page.hint.time",
		"page.solution.time",

		"connect.startSearch",
		"connect.waitForBluetooth",
		"connect.searching",
		"connect.connecting",
		"connect.notFoundRetry",
		"connect.connect",
		"connect.connected",
		"connect.testMode",
		"connect.readyToPlay",
		"connect.wrongProgram",

		"bookProgramOutputString.success",
		"bookProgramOutputString.success",
		"bookProgramOutputNumber.success",
		"bookProgramOutputImage.success",
		"bookProgramOutputGrid.success",
		"bookProgramOutputRGB.success",
		"bookProgramOutputSound.success",
		"bookProgramOutputCombination.success",
		"bookProgramInputButtonA.success",
		"bookProgramInputButtonB.success",
		"bookProgramInputButtonAB.success",
		"bookProgramInputPin.success",
		"bookProgramInputShake.success",
		"bookProgramInputCombination.success",
		"bookProgramCommandStart.success",
		"bookProgramCommandSleep.success",
		"bookProgramCommandClear.success",
		"bookProgramCommandForever.success",
		"bookProgramCommandVariables.success",
		"bookProgramCommandLoops.success",
		"bookProgramCommandRandom.success",
		"bookProgramCommandConditionals.success",
		"bookProgramCommandCombination.success",
		"bookProgramProjectDice.success",
		"bookProgramProjectRockPaperScissors.success",
		"bookProgramProjectPiano.success",
		"bookProgramProjectClap.success",
		"bookProgramProjectTheremin.success",
		"bookProgramProjectThermometer.success",

		"bookProgramOutputString.solution",
		"bookProgramOutputGrid.solution",
		"bookProgramOutputCombination.solution",
		"bookProgramInputShake.solution",
		"bookProgramInputCombination.solution",
		"bookProgramCommandStart.solution",
		"bookProgramCommandSleep.solution",
		"bookProgramCommandClear.solution",
		"bookProgramCommandForever.solution",
		"bookProgramCommandVariables.solution",
		"bookProgramCommandLoops.solution",
		"bookProgramCommandRandom.solution",
		"bookProgramCommandConditionals.solution",
		"bookProgramProjectDice.solution",
		"bookProgramProjectRockPaperScissors.solution",
		"bookProgramProjectClap.solution",
		"bookProgramProjectThermometer.solution",

		"bookProgramOutputString.hintNoAscii",
		"bookProgramOutputGrid.tooManyOrFewEntries",
		"bookProgramOutputCombination.hintNoAscii",
		"bookProgramInputShake.hintNoAscii",
		"bookProgramInputCombination.tooManyOrFewEntriesImage1",
		"bookProgramInputCombination.tooManyOrFewEntriesImage2",
		"bookProgramInputCombination.tooManyOrFewEntriesImage3",
		"bookProgramCommandStart.hintNoAscii",
		"bookProgramCommandSleep.hintTooShortSleep",
		"bookProgramCommandClear.hintTooShortSleep",
		"bookProgramCommandForever.hintTooShortSleep",
		"bookProgramCommandVariables.hintNoAscii",
		"bookProgramCommandLoops.hintTooLowStart",
		"bookProgramCommandLoops.hintTooLowStop",
		"bookProgramCommandLoops.startNotLowerStop",
		"bookProgramCommandLoops.hintTooShortSleep",
		"bookProgramCommandRandom.hintTooLowStart",
		"bookProgramCommandRandom.hintTooLowStop",
		"bookProgramCommandRandom.startNotLowerStop",
		"bookProgramCommandConditionals.hintTooLowStart",
		"bookProgramCommandConditionals.hintTooLowStop",
		"bookProgramCommandConditionals.startNotLowerStop",
		"bookProgramCommandConditionals.hintNoAsciiTextTrue",
		"bookProgramProjectDice.startNotOneFirstHint",
		"bookProgramCommandLoops.hintTooHighStop",
		"bookProgramProjectDice.hintTooShortSleep",
		"bookProgramProjectRockPaperScissors.hintTooShortSleep",
		"bookProgramProjectClap.hintTooLowClapThreshold",
		"bookProgramProjectThermometer.hintTemperatureNotBetween0And100",

		"bookProgramOutputGrid.otherThanZeroOrOne",
		"bookProgramInputCombination.otherThanZeroOrOneImage1",
		"bookProgramInputCombination.otherThanZeroOrOneImage2",
		"bookProgramInputCombination.otherThanZeroOrOneImage3",
		"bookProgramCommandSleep.hintTooLongSleep",
		"bookProgramCommandClear.hintTooLongSleep",
		"bookProgramCommandForever.hintTooLongSleep",
		"bookProgramCommandVariables.hintTooOld",
		"bookProgramCommandLoops.hintTooHighStart",
		"bookProgramCommandLoops.hintTooHighStop",
		"bookProgramCommandLoops.hintTooLongSleep",
		"bookProgramCommandRandom.hintTooHighStart",
		"bookProgramCommandRandom.hintTooHighStop",
		"bookProgramCommandConditionals.hintTooHighStart",
		"bookProgramCommandConditionals.hintTooHighStop",
		"bookProgramCommandConditionals.hintNoAsciiTextFalse",
		"bookProgramProjectDice.startNotOneSecondHint",
		"bookProgramProjectDice.hintTooLongSleep",
		"bookProgramProjectRockPaperScissors.hintTooLongSleep",
		"bookProgramProjectClap.hintTooHighClapThreshold",
		"bookProgramProjectThermometer.hintColdNotLowerNormalTemp",

		]

	private func getLocalizedString(_ localizableString: String, language languageIdentifier: String) -> String? {
		let localized: String
		if let bundlePath = Bundle.main.path(forResource: languageIdentifier, ofType: "lproj"), let bundle = Bundle(path: bundlePath) {
			localized = NSLocalizedString(localizableString, tableName: nil, bundle: bundle, comment: "")
		} else {
			localized = NSLocalizedString(localizableString, comment: "")
		}
		return localized
	}

	private func testLocalizedStrings(language languageIdentifier: String) {
		for localizableString in localizableStrings {
			if let localized = getLocalizedString(localizableString, language: languageIdentifier) {
				XCTAssertNotEqual(localized, localizableString, "Localized string should not be the same as string")
			} else {
				XCTAssertTrue(false, "The string \(localizableString) does not have a localization")
			}
		}
	}

	private func compareLocalizedStrings(languages languageIdentifiers: [String]) {
		for localizableString in localizableStrings {
			let localizedVersions = languageIdentifiers.compactMap { getLocalizedString(localizableString, language: $0) }
			XCTAssertEqual(localizedVersions.count, Array(Set(localizedVersions)).count, "Not all translations of \(localizableString) have different localizations: \(localizedVersions)")
		}
	}

	func testLocalizedDE() {
		testLocalizedStrings(language: "de")
	}

	func testLocalizedEN() {
		testLocalizedStrings(language: "en")
	}

	func testLocalizationsDistinct() {
		compareLocalizedStrings(languages: ["de", "en"])
	}
}
