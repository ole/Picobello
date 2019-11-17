extension Opcode {
  init(pattern: String) throws {
    let parser = OpcodeParser(pattern: pattern)
    self = try parser.parse()
  }
}

/// Parses a string of the form "0001 11df ffff" into an Opcode.
struct OpcodeParser {
  var pattern: String

  func parse() throws -> Opcode {
    var opcode: UInt16 = 0
    var mask: UInt16 = 0
    for c in pattern.utf8 {
      switch c {
      case ASCII.zero:
        opcode = opcode << 1
        mask = mask << 1 + 1
      case ASCII.one:
        opcode = opcode << 1 + 1
        mask = mask << 1 + 1
      case ASCII.b, ASCII.d, ASCII.f, ASCII.k:
        opcode = opcode << 1
        mask = mask << 1
      case ASCII.space:
        continue
      default:
        throw Opcode.Error(message: "Unexpected character: '\(String(Unicode.Scalar(c)))'")
      }
    }
    return Opcode(opcode: opcode, mask: mask)
  }
}

extension Opcode {
  struct Error: Swift.Error {
    var message: String
  }
}

private enum ASCII {
  static let zero = UInt8(ascii: "0")
  static let one = UInt8(ascii: "1")
  static let space = UInt8(ascii: " ")
  static let b = UInt8(ascii: "b")
  static let d = UInt8(ascii: "d")
  static let f = UInt8(ascii: "f")
  static let k = UInt8(ascii: "k")
}
