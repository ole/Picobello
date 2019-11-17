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
