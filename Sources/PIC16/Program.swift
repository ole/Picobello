import HEXFileFormat

public struct Program {
  public var instructions: [Opcode]

  public init(file: HEXFile) throws {
    let bytes: [UInt8] = file.records.flatMap { record -> [UInt8] in
      if case let .data(_, bytes) = record {
        return bytes
      } else {
        return []
      }
    }
    var bitPatterns: [UInt16] = []
    for byteIndex in stride(from: bytes.startIndex, to: bytes.endIndex, by: 2) {
      let lowByte = UInt16(bytes[byteIndex])
      let highByte = UInt16(bytes[byteIndex + 1])
      let word: UInt16 = highByte << 8 + lowByte
      bitPatterns.append(word)
    }
    self.instructions = try bitPatterns.map { bitPattern in
      guard let opcode = Opcode.matching(bitPattern: bitPattern) else {
        throw Opcode.Error(message: "Unknown instruction: \(bitPattern.binary(padTo: 12))")
      }
      return opcode
    }
  }
}

extension Program: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    "Program (\(instructions.count) instructions)"
  }

  public var debugDescription: String {
    """
    Program (\(instructions.count) instructions)
    \(instructions.map(String.init(describing:)).joined(separator: "\n"))
    """
  }
}
