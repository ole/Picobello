/// Named registers in the register file
public struct RegisterFile: RawRepresentable, Equatable {
  public var rawValue: UInt8

  public init?(rawValue: UInt8) {
    try? self.init(number: rawValue)
  }

  public init(number registerNumber: UInt8) throws {
    guard (0..<8).contains(registerNumber) || (16..<32).contains(registerNumber) else {
      throw Opcode.Error(message: "Invalid register file number: \(registerNumber). Must be in range 0..<8 or 16..<32.")
    }
    self.rawValue = registerNumber
  }

  public static let INDF = RegisterFile(rawValue: 0)!
  public static let TMR0 = RegisterFile(rawValue: 1)!
  public static let PCL = RegisterFile(rawValue: 2)!
  public static let STATUS = RegisterFile(rawValue: 3)!
  public static let FSR = RegisterFile(rawValue: 4)!
  public static let OSCCAL = RegisterFile(rawValue: 5)!
  public static let GPIO = RegisterFile(rawValue: 6)!
  public static let CMCON0 = RegisterFile(rawValue: 7)!
}

extension RegisterFile: ExpressibleByIntegerLiteral {
  public init(integerLiteral literal: UInt8) {
    try! self.init(number: literal)
  }
}

extension RegisterFile: CustomStringConvertible {
  public var description: String {
    switch self {
    case .INDF: return "INDF"
    case .TMR0: return "TMR0"
    case .PCL: return "PCL"
    case .STATUS: return "STATUS"
    case .FSR: return "FSR"
    case .OSCCAL: return "OSCCAL"
    case .GPIO: return "GPIO"
    case .CMCON0: return "CMCON0"
    default: return "\(rawValue.hex(padTo: 2))h"
    }
  }
}

/// A bit's index in a byte. The least significant bit is 0, the most significant bit is 7.
public struct Bit: Equatable, RawRepresentable {
  public var rawValue: UInt8

  public init?(rawValue: UInt8) {
    guard rawValue < 8 else {
      return nil
    }
    self.rawValue = rawValue
  }

  // STATUS register bit numbers
  public static let gpioReset: Bit = 7
  public static let comparatorWakeUp: Bit = 6
  public static let notTimeOut: Bit = 4
  public static let notPowerDown: Bit = 3
  public static let zero: Bit = 2
  public static let digitCarry: Bit = 1
  public static let carry: Bit = 0

  // STATUS register aliases
  public static let GPWUF = gpioReset
  public static let CWUF = comparatorWakeUp
  public static let NOT_TO = notTimeOut
  public static let NOT_PD = notPowerDown
  public static let Z = zero
  public static let DC = digitCarry
  public static let C = carry

}

extension Bit: ExpressibleByIntegerLiteral {
  public init(integerLiteral literal: UInt8) {
    self.init(rawValue: literal)!
  }
}

extension Bit: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String { "\(rawValue)" }
  public var debugDescription: String { "Bit: \(rawValue)" }
}

/// Bits of the STATUS register
public struct StatusBit: RawRepresentable, OptionSet {
  public var rawValue: UInt8

  public init() {
    self.rawValue = 0
  }

  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }

  public static let gpioReset = StatusBit(rawValue: 1 << 7)
  public static let comparatorWakeUp = StatusBit(rawValue: 1 << 6)
  public static let notTimeOut = StatusBit(rawValue: 1 << 4)
  public static let notPowerDown = StatusBit(rawValue: 1 << 3)
  public static let zero = StatusBit(rawValue: 1 << 2)
  public static let digitCarry = StatusBit(rawValue: 1 << 1)
  public static let carry = StatusBit(rawValue: 1 << 0)

  // Aliases
  public static let GPWUF = gpioReset
  public static let CWUF = comparatorWakeUp
  public static let NOT_TO = notTimeOut
  public static let NOT_PD = notPowerDown
  public static let Z = zero
  public static let DC = digitCarry
  public static let C = carry
}
