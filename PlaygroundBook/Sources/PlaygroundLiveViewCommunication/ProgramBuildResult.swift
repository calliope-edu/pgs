//
//  ProgramBuildResult.swift
//  Book_Sources
//
//  Created by Tassilo Karge on 27.01.19.
//

import UIKit

public struct ProgramBuildResult: Codable {
	var code: [UInt8] = []
	var methods: [UInt16] = [
		0xffff,
		0xffff,
		0xffff,
		0xffff,
		0xffff,
		]

	func length() -> Int {
		let bytesCode = code.count * 1
		let bytesMethods = methods.count * 2
		return bytesCode + bytesMethods
	}

	func toDebug() -> String {
		let parser = ProgramParser(code: code)
		let pass1 = parser.pass1()
		let pass2 = parser.pass2()
		return
			pass1.joined(separator: "\n") + "\n" +
				pass2.joined(separator: "\n")
	}
}

class ProgramParser {
	let code: [UInt8]
	var labels: Set<UInt> = []

	init(code: [UInt8]) {
		self.code = code
	}

	private func parse(_ targetBlock: ((UInt8, Int, Int, UInt) -> Void)? = nil, _ instructionBlock: ((UInt, [UInt8]) -> Void)? = nil) {
		var it = code.enumerated().makeIterator()
		while let (index, instruction) = it.next() {
			var buffer: [UInt8] = [instruction]

			switch instruction {
			case 0x00...0x06:
				break
			case 0x07, 0x10...0x16:
				guard let (_, offset) = it.next() else { fatalError() }
				let i = Int(index + 2)
				let o = Int(offset)
				let target = UInt(i + o)
				if let block = targetBlock {
					block(instruction, index, o, target)
				}
				buffer.append(offset)
				labels.insert(target)
			case 0x17:
				buffer.append(it.next()!.element)
				buffer.append(it.next()!.element)
			case 0x20, 0x22:
				buffer.append(it.next()!.element)
				buffer.append(it.next()!.element)
			case 0x21, 0x23:
				buffer.append(it.next()!.element)
				buffer.append(it.next()!.element)
				buffer.append(it.next()!.element)
			case 0x30...0x33:
				buffer.append(it.next()!.element)
				buffer.append(it.next()!.element)
			case 0x40...0x42:
				buffer.append(it.next()!.element)
			case 0x50...0x52:
				buffer.append(it.next()!.element)
			case 0x60...0x61:
				buffer.append(it.next()!.element)
			case 0x70:
				break
			case 0x71, 0x72:
				buffer.append(it.next()!.element)
			case 0x73:
				for _ in 0..<25 {
					buffer.append(it.next()!.element)
				}
			case 0x74:
				guard let (_, hi) = it.next() else { fatalError() }
				guard let (_, lo) = it.next() else { fatalError() }
				buffer.append(hi)
				buffer.append(lo)
				let len = hi << 8 | lo
				for _ in 0..<len {
					buffer.append(it.next()!.element)
				}
			case 0x80:
				break
			case 0x81:
				for _ in 0..<4 {
					buffer.append(it.next()!.element)
				}
			case 0x90:
				break
			case 0x91:
				buffer.append(it.next()!.element)
			case 0xa0...0xa2:
				buffer.append(it.next()!.element)
			case 0xa3:
				for _ in 0..<3 {
					buffer.append(it.next()!.element)
				}
			case 0xf0:
				buffer.append(it.next()!.element)
				buffer.append(it.next()!.element)
			case 0xf1:
				buffer.append(it.next()!.element)

			default:
				fatalError()
			}

			if let block = instructionBlock {
				block(UInt(index), buffer)
			}
		}
	}

	func pass1() -> [String] {
		var out: [String] = []
		parse({ instruction, index, o, target in
			out.append(String(format: "%.2x@0x%.4x|  %d -> 0x%.4x", instruction, index, o, target))
		}, nil)
		return out
	}

	func pass2() -> [String] {
		var out: [String] = []
		let me = self
		parse(nil, { index, instruction in
			var line: String = String(format: "0x%.4x|  ", index)
			for (i, b) in instruction.enumerated() {
				let position = index + UInt(i)
				if me.labels.contains(position) {
					line += String(format: "[%.2x] ", b)
				} else {
					line += String(format: " %.2x  ", b)
				}
			}
			out.append(line)
		})
		return out
	}
}

