@testable import Picobello
import XCTest

final class OpcodeParserTests: XCTestCase {
  func testParseOpcodeWithNoOperands() throws {
    let clrwdt = try OpcodeParser(pattern: "0000 0000 0100").parse()
    XCTAssertEqual(clrwdt.opcode, 0b0000_0000_0100)
    XCTAssertEqual(clrwdt.mask, 0b1111_1111_1111)
    XCTAssertEqual(clrwdt.operands, .noOperands)
  }

  func testParseOpcodeWithFileAndDestinationOperands() throws {
    let addwf = try OpcodeParser(pattern: "0001 11df ffff").parse()
    XCTAssertEqual(addwf.opcode, 0b0001_1100_0000)
    XCTAssertEqual(addwf.mask, 0b1111_1100_0000)
    XCTAssertEqual(addwf.operands, .fileAndDestination)
  }

  func testParseOpcodeWithFileOperand() throws {
    let clrf = try OpcodeParser(pattern: "0000 011f ffff").parse()
    XCTAssertEqual(clrf.opcode, 0b0000_0110_0000)
    XCTAssertEqual(clrf.mask, 0b1111_1110_0000)
    XCTAssertEqual(clrf.operands, .file)
  }

  func testParseOpcodeWithFileAndBitOperands() throws {
    let btfsc = try OpcodeParser(pattern: "0110 bbbf ffff").parse()
    XCTAssertEqual(btfsc.opcode, 0b0110_0000_0000)
    XCTAssertEqual(btfsc.mask, 0b1111_0000_0000)
    XCTAssertEqual(btfsc.operands, .fileAndBitNumber)
  }

  func testParseOpcodeWithLiteralOperand() throws {
    let movlw = try OpcodeParser(pattern: "1100 kkkk kkkk").parse()
    XCTAssertEqual(movlw.opcode, 0b1100_0000_0000)
    XCTAssertEqual(movlw.mask, 0b1111_0000_0000)
    XCTAssertEqual(movlw.operands, .literal)
  }

  func testParseOpcodeForGOTO() throws {
    let goto = try OpcodeParser(pattern: "101k kkkk kkkk").parse()
    XCTAssertEqual(goto.opcode, 0b1010_0000_0000)
    XCTAssertEqual(goto.mask, 0b1110_0000_0000)
    XCTAssertEqual(goto.operands, .goto)
  }

  func testParseOpcodeForTRIS() throws {
    let tris = try OpcodeParser(pattern: "0000 0000 0fff").parse()
    XCTAssertEqual(tris.opcode, 0b0000_0000_0000)
    XCTAssertEqual(tris.mask, 0b1111_1111_1000)
    XCTAssertEqual(tris.operands, .tris)
  }
}
