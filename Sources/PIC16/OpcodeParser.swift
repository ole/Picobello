/// Parses a string of the form "0001 11df ffff" into an Opcode.
struct OpcodeParser {
  var pattern: String

  func parse() throws -> Opcode.BitPattern {
    var consumablePattern = pattern[...].utf8
    let (opcode, mask, numberOfOperandBits) = try parseOpcode(in: &consumablePattern)
    let operands = try parseOperandFormat(in: &consumablePattern, numberOfOperandBits: numberOfOperandBits)
    return Opcode.BitPattern(opcode: opcode, mask: mask, operands: operands)
  }

  private func parseOpcode(in pattern: inout Substring.UTF8View) throws -> (opcode: UInt16, mask: UInt16, numberOfOperandBits: Int) {
    var opcodeBits: UInt16 = 0
    var numberOfOpcodeBits = 0
    var cursor = pattern.startIndex
    loop: while cursor < pattern.endIndex {
      switch pattern[cursor] {
      case ASCII.zero:
        opcodeBits = opcodeBits << 1
        numberOfOpcodeBits += 1
        cursor = pattern.index(after: cursor)
      case ASCII.one:
        opcodeBits = opcodeBits << 1 + 1
        numberOfOpcodeBits += 1
        cursor = pattern.index(after: cursor)
      case ASCII.b, ASCII.d, ASCII.f, ASCII.k:
        // Encountered an operand pattern => done parsing opcode
        break loop
      case ASCII.space:
        // Ignore spaces
        cursor = pattern.index(after: cursor)
      case let codeUnit:
        throw Opcode.Error(message: "Unexpected character in pattern: '\(String(Unicode.Scalar(codeUnit)))'")
      }
    }
    guard numberOfOpcodeBits > 0 else {
      throw Opcode.Error(message: "Unexpected end of pattern, expected opcode")
    }
    let maxOpcodeLength = 12
    guard numberOfOpcodeBits <= maxOpcodeLength else {
      throw Opcode.Error(message: "Opcode must be at most \(maxOpcodeLength) bits long")
    }

    let numberOfOperandBits = maxOpcodeLength - numberOfOpcodeBits
    let opcode = opcodeBits << numberOfOperandBits
    let mask: UInt16 = (1 << numberOfOpcodeBits &- 1) << numberOfOperandBits

    pattern = pattern[cursor...]
    return (opcode, mask, numberOfOperandBits)
  }

  private func parseOperandFormat(in pattern: inout Substring.UTF8View, numberOfOperandBits: Int) throws -> Opcode.OperandFormat {
    guard numberOfOperandBits > 0 else {
      return .noOperands
    }
    let patternWithWhitespaceStripped = pattern.filter { $0 != ASCII.space }
    defer {
      pattern = pattern[pattern.endIndex...]
    }
    switch patternWithWhitespaceStripped {
    case Array("dfffff".utf8): return .fileAndDestination
    case Array("fffff".utf8): return .file
    case Array("bbbfffff".utf8): return .fileAndBitNumber
    case Array("kkkkkkkk".utf8): return .literal
    case Array("kkkkkkkkk".utf8): return .goto
    case Array("fff".utf8): return .tris
    default: throw Opcode.Error(message: "Invalid operand pattern: \(String(decoding: pattern, as: UTF8.self))")
    }
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
