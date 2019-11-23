public struct Opcode: Equatable {
  /// The mnemonic of the instruction.
  public var name: String
  /// The bit pattern identifying the opcode and its operands.
  public var bitPattern: BitPattern
  /// The number of cycles the instruction takes to execute.
  public var cycles: Int = 1
  /// The bits of the STATUS register this instruction potentially changes.
  public var statusBits: StatusBit = []
}

extension Opcode {
  public struct BitPattern: Equatable {
    /// The 12-bit opcode of the instruction.
    /// Lower bits that are used for operands should be set to 0.
    public var opcode: UInt16
    /// A bit mask that separates opcode from operands.
    /// The bits that indicate the opcode are 1, the bits that indicate the operands are 0.
    public var mask: UInt16
    /// The types of operands this instruction takes.
    public var operands: Opcode.OperandFormat

    /// Returns true if the given 12-bit bit pattern matches this opcode.
    public func matches(bitPattern other: UInt16) -> Bool {
      other & mask == opcode & mask
    }
  }

  public enum OperandFormat {
    case noOperands
    case file
    case fileAndDestination
    case fileAndBitNumber
    case literal
    case goto
    case tris
  }
}

extension Opcode {
  /// Creates an opcode by parsing a string of the form "0001 11df ffff".
  public init(name: String, pattern: String, cycles: Int = 1, statusBits: StatusBit = []) throws {
    let parser = OpcodeParser(pattern: pattern)
    let bitPattern = try parser.parse()
    self.name = name
    self.bitPattern = bitPattern
    self.cycles = cycles
    self.statusBits = statusBits
  }

  /// Returns the instruction matching the given 12-bit bit pattern, or nil if the
  /// pattern is not a valid instruction.
  public static func matching(bitPattern: UInt16) -> Opcode? {
    allCases.first { $0.bitPattern.matches(bitPattern: bitPattern) }
  }
}

extension Opcode: CaseIterable {
  public static var allCases: [Opcode] = [
    .addwf, .andwf, .clrf, .clrw, .comf, .decf, .decfsz, .incf, .incfsz, .iorwf, .movf, .movwf,
    .nop, .rlf, .rrf, .subwf, .swapf, .xorwf, .bcf, .bsf, .btfsc, .btfss, .andlw, .call, .clrwdt,
    .goto, .iorlw, .movlw, .option, .retlw, .sleep, .tris, .xorlw
  ]
}

extension Opcode: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String { name }

  public var debugDescription: String {
    "\(name) – \(bitPattern.opcode.binary(padTo: 12))"
  }
}

extension Opcode {
  public static let addwf  = try! Opcode(name: "addwf",  pattern: "0001 11df ffff", statusBits: [.C, .DC, .Z])
  public static let andwf  = try! Opcode(name: "andwf",  pattern: "0001 01df ffff", statusBits: .Z)
  public static let clrf   = try! Opcode(name: "clrf",   pattern: "0000 011f ffff", statusBits: .Z)
  public static let clrw   = try! Opcode(name: "clrw",   pattern: "0000 0100 0000", statusBits: .Z)
  public static let comf   = try! Opcode(name: "comf",   pattern: "0010 01df ffff", statusBits: .Z)
  public static let decf   = try! Opcode(name: "decf",   pattern: "0000 11df ffff", statusBits: .Z)
  public static let decfsz = try! Opcode(name: "decfsz", pattern: "0010 11df ffff")
  public static let incf   = try! Opcode(name: "incf",   pattern: "0010 10df ffff", statusBits: .Z)
  public static let incfsz = try! Opcode(name: "incfsz", pattern: "0011 11df ffff")
  public static let iorwf  = try! Opcode(name: "iorwf",  pattern: "0001 00df ffff", statusBits: .Z)
  public static let movf   = try! Opcode(name: "movf",   pattern: "0010 00df ffff", statusBits: .Z)
  public static let movwf  = try! Opcode(name: "movwf",  pattern: "0000 001f ffff")
  public static let nop    = try! Opcode(name: "nop",    pattern: "0000 0000 0000")
  public static let rlf    = try! Opcode(name: "rlf",    pattern: "0011 01df ffff", statusBits: .C)
  public static let rrf    = try! Opcode(name: "rrf",    pattern: "0011 00df ffff", statusBits: .C)
  public static let subwf  = try! Opcode(name: "subwf",  pattern: "0000 10df ffff", statusBits: [.C, .DC, .Z])
  public static let swapf  = try! Opcode(name: "swapf",  pattern: "0011 10df ffff")
  public static let xorwf  = try! Opcode(name: "xorwf",  pattern: "0001 10df ffff", statusBits: .Z)

  public static let bcf    = try! Opcode(name: "bcf",    pattern: "0100 bbbf ffff")
  public static let bsf    = try! Opcode(name: "bsf",    pattern: "0101 bbbf ffff")
  public static let btfsc  = try! Opcode(name: "btfsc",  pattern: "0110 bbbf ffff")
  public static let btfss  = try! Opcode(name: "btfss",  pattern: "0111 bbbf ffff")

  public static let andlw  = try! Opcode(name: "andlw",  pattern: "1110 kkkk kkkk", statusBits: .Z)
  public static let call   = try! Opcode(name: "call",   pattern: "1001 kkkk kkkk", cycles: 2)
  public static let clrwdt = try! Opcode(name: "clrwdt", pattern: "0000 0000 0100", statusBits: [.NOT_TO, .NOT_PD])
  public static let goto   = try! Opcode(name: "goto",   pattern: "101k kkkk kkkk", cycles: 2)
  public static let iorlw  = try! Opcode(name: "iorlw",  pattern: "1101 kkkk kkkk", statusBits: .Z)
  public static let movlw  = try! Opcode(name: "movlw",  pattern: "1100 kkkk kkkk")
  public static let option = try! Opcode(name: "option", pattern: "0000 0000 0010")
  public static let retlw  = try! Opcode(name: "retlw",  pattern: "1000 kkkk kkkk", cycles: 2)
  public static let sleep  = try! Opcode(name: "sleep",  pattern: "0000 0000 0011", statusBits: [.NOT_TO, .NOT_PD])
  public static let tris   = try! Opcode(name: "tris",   pattern: "0000 0000 0fff")
  public static let xorlw  = try! Opcode(name: "xorlw",  pattern: "1111 kkkk kkkk", statusBits: .Z)
}

