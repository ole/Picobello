import HEXFileFormat
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
    XCTAssertEqual(program.instructions.count, 8)
    XCTAssertEqual(program.instructions, [
      .movwf,
      .movlw,
      .option,
      .movlw,
      .tris,
      .btfsc,
      .goto,
      .btfsc,
    ])
  }
}
