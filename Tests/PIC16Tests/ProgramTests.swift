import HexHexHex
import PIC16
import XCTest

final class ProgramTests: XCTestCase {
  func testInitFromHexFile() throws {
    let hex = """
      :020000040000FA
      :1000000025001C0C0200080C06006306590AE306D2
      :00000001FF
      """
    let hexFile = try HEXFile(text: hex)
    let program = try Program(file: hexFile)
    XCTAssertEqual(program.records.count, 8)
    XCTAssertEqual(program.records, [
      .statement(Statement(address: 0x00, instruction: .movwf(.OSCCAL))),
      .statement(Statement(address: 0x01, instruction: .movlw(0b0001_1100))),
      .statement(Statement(address: 0x02, instruction: .option)),
      .statement(Statement(address: 0x03, instruction: .movlw(0b1000))),
      .statement(Statement(address: 0x04, instruction: .tris(.GPIO))),
      .statement(Statement(address: 0x05, instruction: .btfsc(.STATUS, bit: .NOT_PD))),
      .statement(Statement(address: 0x06, instruction: .goto(0x59))),
      .statement(Statement(address: 0x07, instruction: .btfsc(.STATUS, bit: .GPWUF))),
    ])
  }
}
