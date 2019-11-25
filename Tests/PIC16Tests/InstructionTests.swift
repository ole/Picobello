import PIC16
import XCTest

final class InstructionTests: XCTestCase {
  func testClrw() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0100_0000)
    XCTAssertEqual(instruction, .clrw)
  }

  func testNop() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0000_0000)
    XCTAssertEqual(instruction, .nop)
  }

  func testClrwdt() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0000_0100)
    XCTAssertEqual(instruction, .clrwdt)
  }

  func testOption() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0000_0010)
    XCTAssertEqual(instruction, .option)
  }

  func testSleep() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0000_0011)
    XCTAssertEqual(instruction, .sleep)
  }

  func testClrf() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0110_0110)
    XCTAssertEqual(instruction, .clrf(.GPIO))
  }

  func testClrfThrowsForInvalidRegisterFileNumberBetween8And15() throws {
    XCTAssertThrowsError(try Instruction(bitPattern: 0b0000_0110_1000))
    XCTAssertThrowsError(try Instruction(bitPattern: 0b0000_0110_1101))
    XCTAssertThrowsError(try Instruction(bitPattern: 0b0000_0110_1111))
  }

  func testMovwf() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0011_0110)
    XCTAssertEqual(instruction, .movwf(22))
  }

  func testAddwfWithDestinationW() throws {
    let instruction = try Instruction(bitPattern: 0b0001_1100_0000)
    XCTAssertEqual(instruction, .addwf(.INDF, destination: .workingRegister))
  }

  func testMovfWithDestinationF() throws {
    let instruction = try Instruction(bitPattern: 0b0010_0011_0000)
    XCTAssertEqual(instruction, .movf(16, destination: .fileRegister))
  }

  func testBtfsc() throws {
    let instruction = try Instruction(bitPattern: 0b0110_1011_1111)
    XCTAssertEqual(instruction, .btfsc(31, bit: 5))
  }

  func testMovlw() throws {
    let instruction = try Instruction(bitPattern: 0b1100_1010_0101)
    XCTAssertEqual(instruction, .movlw(0b1010_0101))
  }

  func testCall() throws {
    let instruction = try Instruction(bitPattern: 0b1001_1111_1001)
    XCTAssertEqual(instruction, .call(0xf9))
  }

  func testGotoWith8BitAddress() throws {
    let instruction = try Instruction(bitPattern: 0b1010_1110_1010)
    XCTAssertEqual(instruction, .goto(0b1110_1010))
  }

  func testGotoWith9BitAddress() throws {
    let instruction = try Instruction(bitPattern: 0b1011_1101_1000)
    XCTAssertEqual(instruction, .goto(0b1_11101_1000))
  }

  func testTrisGPIO() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0000_0110)
    XCTAssertEqual(instruction, .tris(.GPIO))
  }

  func testTrisCMCON0() throws {
    let instruction = try Instruction(bitPattern: 0b0000_0000_0111)
    XCTAssertEqual(instruction, .tris(.CMCON0))
  }

  func testTrisThrowsForInvalidOperand() {
    XCTAssertThrowsError(try Instruction(bitPattern: 0b0000_0000_0001))
  }
}
