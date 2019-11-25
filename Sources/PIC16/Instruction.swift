public struct Instruction: Equatable {
  public var opcode: Opcode
  public var operands: Operands

  /// Type-safe representation for the operands of an instruction.
  public enum Operands: Equatable {
    /// The instruction has no operands. The entire 12-bit instruction identifies the opcode.
    case noOperands
    case file(FileOperand)
    case fileAndDestination(FileAndDestinationOperands)
    case fileAndBitNumber(FileAndBitNumberOperand)
    case literal(LiteralOperand)
    case goto(GotoOperand)
    case tris(TrisOperand)
  }

  public init(opcode: Opcode, operands: Operands) {
    self.opcode = opcode
    self.operands = operands
  }
}

extension Instruction {
  /// Creates an instruction from a 12-bit bit pattern.
  public init(bitPattern: UInt16) throws {
    guard let opcode = Opcode.matching(bitPattern: bitPattern) else {
      throw Opcode.Error(message: "Invalid opcode: 0b\(String(bitPattern, radix: 2))")
    }
    self.opcode = opcode

    let operandBits = bitPattern & ~opcode.bitPattern.mask
    switch opcode.bitPattern.operands {
    case .noOperands:
      self.operands = .noOperands
    case .file:
      self.operands = .file(try FileOperand(bitPattern: operandBits))
    case .fileAndDestination:
      self.operands = .fileAndDestination(try FileAndDestinationOperands(bitPattern: operandBits))
    case .fileAndBitNumber:
      self.operands = .fileAndBitNumber(try FileAndBitNumberOperand(bitPattern: operandBits))
    case .literal:
      self.operands = .literal(LiteralOperand(bitPattern: operandBits))
    case .goto:
      self.operands = .goto(GotoOperand(bitPattern: operandBits))
    case .tris:
      self.operands = .tris(try TrisOperand(bitPattern: operandBits))
    }
  }
}

extension Instruction: CustomStringConvertible {
  public var description: String {
    switch operands {
    case .noOperands:
      return "\(opcode)"
    case .file, .fileAndDestination, .fileAndBitNumber, .literal, .goto, .tris:
      return "\(opcode) \(operands)"
    }
  }
}

extension Instruction.Operands: CustomStringConvertible {
  public var description: String {
    switch self {
    case .noOperands: return ""
    case .file(let op): return "\(op)"
    case .fileAndDestination(let op): return "\(op)"
    case .fileAndBitNumber(let op): return "\(op)"
    case .literal(let op): return "\(op)"
    case .goto(let op): return "\(op)"
    case .tris(let op): return "\(op)"
    }
  }
}

extension Instruction {
  public static let clrw = Instruction(opcode: .clrw, operands: .noOperands)
  public static let nop = Instruction(opcode: .nop, operands: .noOperands)
  public static let clrwdt = Instruction(opcode: .clrwdt, operands: .noOperands)
  public static let option = Instruction(opcode: .option, operands: .noOperands)
  public static let sleep = Instruction(opcode: .sleep, operands: .noOperands)

  public static func clrf(_ f: RegisterFile) -> Instruction {
    Instruction(opcode: .clrf, operands: .file(FileOperand(f)))
  }

  public static func movwf(_ f: RegisterFile) -> Instruction {
    Instruction(opcode: .movwf, operands: .file(FileOperand(f)))
  }

  public static func addwf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .addwf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func andwf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .andwf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func comf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .comf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func decf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .decf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func decfsz(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .decfsz, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func incf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .incf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func incfsz(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .incfsz, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func iorwf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .iorwf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func movf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .movf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func rlf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .rlf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func rrf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .rrf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func subwf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .subwf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func swapf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .swapf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func xorwf(_ f: RegisterFile, destination: FileAndDestinationOperands.Destination = .workingRegister) -> Instruction {
    Instruction(opcode: .xorwf, operands: .fileAndDestination(FileAndDestinationOperands(f, destination: destination)))
  }

  public static func bcf(_ f: RegisterFile, bit bitNumber: Bit) -> Instruction {
    Instruction(opcode: .bcf, operands: .fileAndBitNumber(FileAndBitNumberOperand(f, bit: bitNumber)))
  }

  public static func bsf(_ f: RegisterFile, bit bitNumber: Bit) -> Instruction {
    Instruction(opcode: .bsf, operands: .fileAndBitNumber(FileAndBitNumberOperand(f, bit: bitNumber)))
  }

  public static func btfsc(_ f: RegisterFile, bit bitNumber: Bit) -> Instruction {
    Instruction(opcode: .btfsc, operands: .fileAndBitNumber(FileAndBitNumberOperand(f, bit: bitNumber)))
  }

  public static func btfss(_ f: RegisterFile, bit bitNumber: Bit) -> Instruction {
    Instruction(opcode: .btfss, operands: .fileAndBitNumber(FileAndBitNumberOperand(f, bit: bitNumber)))
  }

  public static func andlw(_ literal: UInt8) -> Instruction {
    Instruction(opcode: .andlw, operands: .literal(LiteralOperand(literal)))
  }

  public static func call(_ literal: UInt8) -> Instruction {
    Instruction(opcode: .call, operands: .literal(LiteralOperand(literal)))
  }

  public static func iorlw(_ literal: UInt8) -> Instruction {
    Instruction(opcode: .iorlw, operands: .literal(LiteralOperand(literal)))
  }

  public static func movlw(_ literal: UInt8) -> Instruction {
    Instruction(opcode: .movlw, operands: .literal(LiteralOperand(literal)))
  }

  public static func retlw(_ literal: UInt8) -> Instruction {
    Instruction(opcode: .retlw, operands: .literal(LiteralOperand(literal)))
  }

  public static func xorlw(_ literal: UInt8) -> Instruction {
    Instruction(opcode: .xorlw, operands: .literal(LiteralOperand(literal)))
  }

  public static func goto(_ branchAddress: UInt16) -> Instruction {
    Instruction(opcode: .goto, operands: .goto(GotoOperand(bitPattern: branchAddress)))
  }

  public static func tris(_ register: TrisOperand.TrisRegister) -> Instruction {
    Instruction(opcode: .tris, operands: .tris(TrisOperand(register)))
  }
}

/// The operand for a byte-oriented file register instruction without destination flag.
///
///      11                             5 4                     0
///     ┌────────────────────────────────┬───────────────────────┐
///     │           OPCODE               │   f (5-bit FILE #)    │
///     └────────────────────────────────┴───────────────────────┘
///
public struct FileOperand: Equatable, CustomStringConvertible {
  public var registerFileAddress: RegisterFile

  public init(_ f: RegisterFile) {
    self.registerFileAddress = f
  }

  init(bitPattern: UInt16) throws {
    let registerNumber = UInt8(clamping: bitPattern & 0b1_1111)
    self.registerFileAddress = try RegisterFile(number: registerNumber)
  }

  public var description: String {
    "\(registerFileAddress)"
  }
}

/// The operands for a byte-oriented file register instruction with destination flag.
///
///      11                         6  5  4                     0
///     ┌────────────────────────────┬───┬───────────────────────┐
///     │           OPCODE           │ d │   f (5-bit FILE #)    │
///     └────────────────────────────┴───┴───────────────────────┘
///
public struct FileAndDestinationOperands: Equatable, CustomStringConvertible {
  public enum Destination: UInt8, CustomStringConvertible {
    case workingRegister = 0
    case fileRegister = 1

    public var description: String {
      switch self {
      case .workingRegister: return "w"
      case .fileRegister: return "f"
      }
    }
  }

  public var registerFileAddress: RegisterFile
  public var destination: Destination

  public init(_ f: RegisterFile, destination: Destination = .workingRegister) {
    self.registerFileAddress = f
    self.destination = destination
  }

  init(bitPattern: UInt16) throws {
    let registerNumber = UInt8(clamping: bitPattern & 0b1_1111)
    self.registerFileAddress = try RegisterFile(number: registerNumber)
    self.destination = (bitPattern & 0b10_0000) >> 5 == 1 ? .fileRegister : .workingRegister
  }

  public var description: String {
    "\(registerFileAddress), \(destination)"
  }
}

/// The operands for a bit-oriented file register instruction.
///
///      11               8 7           5 4                     0
///     ┌──────────────────┬─────────────┬───────────────────────┐
///     │      OPCODE      │  b (BIT #)  │   f (5-bit FILE #)    │
///     └──────────────────┴─────────────┴───────────────────────┘
///
public struct FileAndBitNumberOperand: Equatable, CustomStringConvertible {
  public var registerFileAddress: RegisterFile
  public var bit: Bit

  public init(_ f: RegisterFile, bit: Bit) {
    self.registerFileAddress = f
    self.bit = bit
  }

  init(bitPattern: UInt16) throws {
    let registerNumber = UInt8(clamping: bitPattern & 0b1_1111)
    self.registerFileAddress = try RegisterFile(number: registerNumber)
    let bitNumber = UInt8(clamping: bitPattern & 0b1110_0000) >> 5
    self.bit = Bit(rawValue: bitNumber)!
  }

  public var description: String {
    "\(registerFileAddress), \(bit)"
  }
}

/// The operand for an instruction that takes an 8-bit literal.
///
///      11               8 7                                   0
///     ┌──────────────────┬─────────────────────────────────────┐
///     │      OPCODE      │          k (8-bit literal)          │
///     └──────────────────┴─────────────────────────────────────┘
///
public struct LiteralOperand: Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {
  public var literal: UInt8

  public init(_ literal: UInt8) {
    self.literal = literal
  }

  init(bitPattern: UInt16) {
    self.literal = UInt8(clamping: bitPattern & 0b1111_1111)
  }

  public init(integerLiteral literal: UInt8) {
    self.init(literal)
  }

  public var description: String {
    "\(literal)"
  }
}

/// The operand for the the GOTO instruction. GOTO is the only instruction that
/// takes a 9-bit literal as its operand.
///
///      11          9 8                                        0
///     ┌─────────────┬──────────────────────────────────────────┐
///     │   OPCODE    │            k (9-bit literal)             │
///     └─────────────┴──────────────────────────────────────────┘
///
public struct GotoOperand: Equatable, CustomStringConvertible {
  public var branchAddress: UInt16

  init(bitPattern: UInt16) {
    self.branchAddress = bitPattern & 0b1_1111_1111
  }

  public var description: String {
    "\(branchAddress.hex(padTo: 2))h"
  }
}

/// The operand for the TRIS instruction.
public struct TrisOperand: Equatable, CustomStringConvertible {
  public enum TrisRegister: UInt8, CustomStringConvertible {
    case GPIO = 6
    case CMCON0 = 7

    public var description: String {
      switch self {
      case .GPIO: return "GPIO"
      case .CMCON0: return "CMCON0"
      }
    }
  }

  public var register: TrisRegister

  public init(_ register: TrisRegister) {
    self.register = register
  }

  init(bitPattern: UInt16) throws {
    guard let register = TrisRegister(rawValue: UInt8(clamping: bitPattern & 0b111)) else {
      throw Opcode.Error(message: "Invalid operand for TRIS instruction: b'\(String(UInt8(clamping: bitPattern & 0b111), radix: 2))'")
    }
    self.register = register
  }

  public var description: String {
    "\(register)"
  }
}
