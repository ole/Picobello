public struct Opcode {
  public var opcode: UInt16
  /// The bits that indicate the instruction are 1, the bits that indicate the arguments are 0.
  public var mask: UInt16
}

extension Opcode {
  public static let addwf  = try! Opcode(pattern: "0001 11df ffff")
  public static let andwf  = try! Opcode(pattern: "0001 01df ffff")
  public static let clrf   = try! Opcode(pattern: "0000 011f ffff")
  public static let clrw   = try! Opcode(pattern: "0000 0100 0000")
  public static let comf   = try! Opcode(pattern: "0010 01df ffff")
  public static let decf   = try! Opcode(pattern: "0000 11df ffff")
  public static let decfsz = try! Opcode(pattern: "0010 11df ffff")
  public static let incf   = try! Opcode(pattern: "0010 10df ffff")
  public static let incfsz = try! Opcode(pattern: "0011 11df ffff")
  public static let iorwf  = try! Opcode(pattern: "0001 00df ffff")
  public static let movf   = try! Opcode(pattern: "0010 00df ffff")
  public static let movwf  = try! Opcode(pattern: "0000 001f ffff")
  public static let nop    = try! Opcode(pattern: "0000 0000 0000")
  public static let rlf    = try! Opcode(pattern: "0011 01df ffff")
  public static let rrf    = try! Opcode(pattern: "0011 00df ffff")
  public static let subwf  = try! Opcode(pattern: "0000 10df ffff")
  public static let swapf  = try! Opcode(pattern: "0011 10df ffff")
  public static let xorwf  = try! Opcode(pattern: "0001 10df ffff")

  public static let bcf    = try! Opcode(pattern: "0100 bbbf ffff")
  public static let bsf    = try! Opcode(pattern: "0101 bbbf ffff")
  public static let btfsc  = try! Opcode(pattern: "0110 bbbf ffff")
  public static let btfss  = try! Opcode(pattern: "0111 bbbf ffff")

  public static let andlw  = try! Opcode(pattern: "1110 kkkk kkkk")
  public static let call   = try! Opcode(pattern: "1001 kkkk kkkk")
  public static let clrwdt = try! Opcode(pattern: "0000 0000 0100")
  public static let goto   = try! Opcode(pattern: "101k kkkk kkkk")
  public static let iorlw  = try! Opcode(pattern: "1101 kkkk kkkk")
  public static let movlw  = try! Opcode(pattern: "1100 kkkk kkkk")
  public static let option = try! Opcode(pattern: "0000 0000 0010")
  public static let retlw  = try! Opcode(pattern: "1000 kkkk kkkk")
  public static let sleep  = try! Opcode(pattern: "0000 0000 0011")
  public static let tris   = try! Opcode(pattern: "0000 0000 0fff")
  public static let xorlw  = try! Opcode(pattern: "1111 kkkk kkkk")
}
