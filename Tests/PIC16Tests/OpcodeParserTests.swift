@testable import PIC16
import XCTest

final class OpcodeParserTests: XCTestCase {
  func testParseOpcodeWithNoArguments() throws {
    let clrwdt = try OpcodeParser(pattern: "0000 0000 0100").parse()
    XCTAssertEqual(clrwdt.opcode, 0b0000_0000_0100)
    XCTAssertEqual(clrwdt.mask, 0b1111_1111_1111)
  }

  func testParseOpcodeWithFileAndDestinationArguments() throws {
    let addwf = try OpcodeParser(pattern: "0001 11df ffff").parse()
    XCTAssertEqual(addwf.opcode, 0b0001_1100_0000)
    XCTAssertEqual(addwf.mask, 0b1111_1100_0000)
  }

  func testParseOpcodeWithFileAndBitArguments() throws {
    let btfsc = try OpcodeParser(pattern: "0110 bbbf ffff").parse()
    XCTAssertEqual(btfsc.opcode, 0b0110_0000_0000)
    XCTAssertEqual(btfsc.mask, 0b1111_0000_0000)
  }

  func testParseOpcodeWithLiteralArgument() throws {
    let movlw = try OpcodeParser(pattern: "1100 kkkk kkkk").parse()
    XCTAssertEqual(movlw.opcode, 0b1100_0000_0000)
    XCTAssertEqual(movlw.mask, 0b1111_0000_0000)
  }
}
