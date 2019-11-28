import Picobello
import XCTest

final class RegisterTests: XCTestCase {
  func testRegisterFileThrowsForInvalidRegisterNumberBetween8And15() {
    XCTAssertNoThrow(try RegisterFile(number: 7))
    XCTAssertThrowsError(try RegisterFile(number: 8))
    XCTAssertThrowsError(try RegisterFile(number: 9))
    XCTAssertThrowsError(try RegisterFile(number: 10))
    XCTAssertThrowsError(try RegisterFile(number: 11))
    XCTAssertThrowsError(try RegisterFile(number: 12))
    XCTAssertThrowsError(try RegisterFile(number: 13))
    XCTAssertThrowsError(try RegisterFile(number: 14))
    XCTAssertThrowsError(try RegisterFile(number: 15))
    XCTAssertNoThrow(try RegisterFile(number: 16))
  }
}
