import Foundation
import HEXFileFormat

struct PICHEXParser {
  var hexRecords: [HEXFileFormat.Record]

  func parse() throws -> [Program.Record] {
    var programRecords: [Program.Record] = []
    var cursor = hexRecords.startIndex
    loop: while cursor < hexRecords.endIndex {
      let line = cursor + 1
      let hexRecord = hexRecords[cursor]
      switch hexRecord {
      case .data(let address, let bytes):
        let newRecords = try parseDataRecord(line: line, address: address, bytes: bytes)
        programRecords.append(contentsOf: newRecords)

      case .endOfFile:
        guard hexRecords.index(after: cursor) == hexRecords.endIndex else {
          throw Error(line: line, message: "File continues after endOfFile record")
        }
        break loop

      case .extendedLinearAddress(let upperAddressBits):
        guard upperAddressBits == 0 else {
          throw Error(line: line, message: "Unexpected extendedLinearAddress \(upperAddressBits), expected 0")
        }

      case .startSegmentAddress,
           .extentedSegmentAddress,
           .startLinearAddress:
        throw Error(line: line, message: "Unexpected record type \(hexRecord.kind)")
      }
      cursor = hexRecords.index(after: cursor)
    }
    return programRecords
  }

  private func parseDataRecord(line: Int, address: Address16, bytes: [UInt8]) throws -> [Program.Record] {
    // PIC uses 12 bits per word (a word can be an instructions or configuration data).
    // A single 12-bit word is stored in two 8-bit bytes in the .hex file.
    // Because each word takes up two bytes, the address value in the .hex file must be halved.
    guard address.rawValue.isMultiple(of: 2) else {
      throw Error(line: line, message: "Address \(address) is unexpectedly not even")
    }
    let startAddress = address.rawValue / 2

    switch startAddress {
    case 0xfff:
      // The configuration word (__CONFIG directive in the assembler) is stored
      // at logical address 0xfff in the .hex file.
      return [Program.Record.config(try parseConfigWord(line: line, bytes: bytes))]

    default:
      return try parseStatements(line: line, startAddress: startAddress, bytes: bytes)
        .map(Program.Record.statement)
    }
  }

  private func parseConfigWord(line: Int, bytes: [UInt8]) throws -> UInt16 {
    guard bytes.count == 2 else {
      throw Error(line: line, message: "Unexpected configuration word length; expected 2 bytes")
    }
    // Words are stored in little-endian byte order.
    let lowByte = UInt16(bytes[0])
    let highByte = UInt16(bytes[1])
    let configurationWord = highByte << 8 + lowByte
    return configurationWord
  }

  private func parseStatements(line: Int, startAddress: UInt16, bytes: [UInt8]) throws -> [Statement] {
    guard bytes.count.isMultiple(of: 2) else {
      throw Error(line: line, message: "Expected an even number of data bytes; must always come in pairs")
    }
    let words: [UInt16] = stride(from: bytes.startIndex, to: bytes.endIndex, by: 2).map { byteIndex in
      // Words are stored in little-endian byte order.
      let lowByte = UInt16(bytes[byteIndex])
      let highByte = UInt16(bytes[byteIndex + 1])
      return highByte << 8 + lowByte
    }
    return try zip(startAddress..., words).map { tuple in
      let (address, bitPattern) = tuple
      guard let shortAddress = UInt8(exactly: address) else {
        throw Error(line: line, message: "Address \(address.hex(padTo: 2))h is too large; must be FFh or smaller.")
      }
      return try Statement(address: shortAddress, instruction: Instruction(bitPattern: bitPattern))
    }
  }
}

extension PICHEXParser {
  struct Error: Swift.Error {
    var line: Int
    var message: String
  }
}

extension PICHEXParser.Error: CustomNSError {
  public static var errorDomain: String { "PICHEXParser.Error" }
  public var errorCode: Int { 1000 }
  public var errorUserInfo: [String : Any] {
    [NSLocalizedDescriptionKey: "PICHEXParser.Error: Line \(line): \(message)"]
  }
}
