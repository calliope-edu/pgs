//
//  DataExtensionTest.swift
//  BookSourcesTests
//
//  Created by Tassilo Karge on 26.01.19.
//

import XCTest
@testable import Book_Sources

class DataExtensionTest: XCTestCase {

    func testConversion() {
		let i1 : Int = 123
		let i2 : Int = -123
		let i3 : UInt = 123

		let i4 : Int32 = int32(i1)
		let i5 : Int32 = int32(i2)
		let i6 : UInt32 = uint32(i1)

		let i7 : Int16 = int16(i1)
		let i8 : Int16 = int16(i2)
		let i9 : UInt16 = uint16(i1)

		let i10 : Int8 = int8(i1)
		let i11 : Int8 = int8(i2)
		let i12 : UInt8 = uint8(i1)

		XCTAssertEqual(Int(littleEndianData: i1.littleEndianData), i1)
		XCTAssertEqual(Int(littleEndianData: i2.littleEndianData), i2)
		XCTAssertEqual(UInt(littleEndianData: i3.littleEndianData), i3)

		XCTAssertEqual(Int32(littleEndianData: i4.littleEndianData), i4)
		XCTAssertEqual(Int32(littleEndianData: i5.littleEndianData), i5)
		XCTAssertEqual(UInt32(littleEndianData: i6.littleEndianData), i6)

		XCTAssertEqual(Int16(littleEndianData: i7.littleEndianData), i7)
		XCTAssertEqual(Int16(littleEndianData: i8.littleEndianData), i8)
		XCTAssertEqual(UInt16(littleEndianData: i9.littleEndianData), i9)

		XCTAssertEqual(Int8(littleEndianData: i10.littleEndianData), i10)
		XCTAssertEqual(Int8(littleEndianData: i11.littleEndianData), i11)
		XCTAssertEqual(UInt8(littleEndianData: i12.littleEndianData), i12)
    }

}
