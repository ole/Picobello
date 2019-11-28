import Picobello
import XCTest

final class OpcodeTests: XCTestCase {
  func testOpcodeMatchesBitPattern() throws {
    let movwf = try Opcode(name: "movfw", pattern: "0000 001f ffff")
    XCTAssertTrue(movwf.bitPattern.matches(bitPattern: 0b0000_0010_1010))
    XCTAssertTrue(movwf.bitPattern.matches(bitPattern: 0b0000_0010_0000))
    XCTAssertTrue(movwf.bitPattern.matches(bitPattern: 0b0000_0011_1111))
    XCTAssertFalse(movwf.bitPattern.matches(bitPattern: 0b1000_0010_0000))
  }

  func testFindOpcodeMatchingBitPattern() throws {
    let bitPattern: UInt16 = 0b0000_0010_1010
    XCTAssertEqual(Opcode.matching(bitPattern: bitPattern), .movwf)
  }

  func testOpcodeAllCasesIsComplete() {
    // This test is also useful because it instantiates all opcode constants
    // and implicitly tests that their pattern strings can be parsed.
    XCTAssertEqual(Opcode.allCases.count, 33)
    XCTAssertTrue(Opcode.allCases.contains(.addwf))
    XCTAssertTrue(Opcode.allCases.contains(.andwf))
    XCTAssertTrue(Opcode.allCases.contains(.clrf))
    XCTAssertTrue(Opcode.allCases.contains(.clrw))
    XCTAssertTrue(Opcode.allCases.contains(.comf))
    XCTAssertTrue(Opcode.allCases.contains(.decf))
    XCTAssertTrue(Opcode.allCases.contains(.decfsz))
    XCTAssertTrue(Opcode.allCases.contains(.incf))
    XCTAssertTrue(Opcode.allCases.contains(.incfsz))
    XCTAssertTrue(Opcode.allCases.contains(.iorwf))
    XCTAssertTrue(Opcode.allCases.contains(.movf))
    XCTAssertTrue(Opcode.allCases.contains(.movwf))
    XCTAssertTrue(Opcode.allCases.contains(.nop))
    XCTAssertTrue(Opcode.allCases.contains(.rlf))
    XCTAssertTrue(Opcode.allCases.contains(.rrf))
    XCTAssertTrue(Opcode.allCases.contains(.subwf))
    XCTAssertTrue(Opcode.allCases.contains(.swapf))
    XCTAssertTrue(Opcode.allCases.contains(.xorwf))
    XCTAssertTrue(Opcode.allCases.contains(.bcf))
    XCTAssertTrue(Opcode.allCases.contains(.bsf))
    XCTAssertTrue(Opcode.allCases.contains(.btfsc))
    XCTAssertTrue(Opcode.allCases.contains(.btfss))
    XCTAssertTrue(Opcode.allCases.contains(.andlw))
    XCTAssertTrue(Opcode.allCases.contains(.call))
    XCTAssertTrue(Opcode.allCases.contains(.clrwdt))
    XCTAssertTrue(Opcode.allCases.contains(.goto))
    XCTAssertTrue(Opcode.allCases.contains(.iorlw))
    XCTAssertTrue(Opcode.allCases.contains(.movlw))
    XCTAssertTrue(Opcode.allCases.contains(.option))
    XCTAssertTrue(Opcode.allCases.contains(.retlw))
    XCTAssertTrue(Opcode.allCases.contains(.sleep))
    XCTAssertTrue(Opcode.allCases.contains(.tris))
    XCTAssertTrue(Opcode.allCases.contains(.xorlw))
  }
}
