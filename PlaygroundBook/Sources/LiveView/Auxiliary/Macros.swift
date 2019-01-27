//
//  File.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 27.01.19.
//

import UIKit


func LOG(_ message: Any, fileName: String = #file, lineNumber: Int = #line) {
	let lastPathComponent = (fileName as NSString).lastPathComponent
	let filenameOnly = lastPathComponent.components(separatedBy: ".")[0]
	let extendedMessage = "\(filenameOnly):\(lineNumber)| \(message)"

	print(extendedMessage)
}

func ERR(_ message: Any, fileName: String = #file, lineNumber: Int = #line) {
	let lastPathComponent = (fileName as NSString).lastPathComponent
	let filenameOnly = lastPathComponent.components(separatedBy: ".")[0]
	let extendedMessage = "\(filenameOnly):\(lineNumber) \(message)"

	print(extendedMessage)
}
