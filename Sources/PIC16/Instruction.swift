/// A CPU instruction in the PIC16 instruction set.
public struct Instruction {
  /// The mnemonic of the instruction.
  public var name: String
  /// The instruction's opcode.
  public var opcode: Opcode
  /// The number of cycles the instruction takes to execute.
  public var cycles: Int = 1
  /// The bits of the STATUS register this instruction potentially changes.
  public var statusBits: StatusBit = []
}

extension Instruction {
  public static let addwf  = Instruction(name: "addwf", opcode: .addwf, statusBits: [.C, .DC, .Z])
  public static let andwf  = Instruction(name: "andwf", opcode: .andwf, statusBits: .Z)
  public static let clrf   = Instruction(name: "clrf", opcode: .clrf, statusBits: .Z)
  public static let clrw   = Instruction(name: "clrw", opcode: .clrw, statusBits: .Z)
  public static let comf   = Instruction(name: "comf", opcode: .comf, statusBits: .Z)
  public static let decf   = Instruction(name: "decf", opcode: .decf, statusBits: .Z)
  public static let decfsz = Instruction(name: "decfsz", opcode: .decfsz)
  public static let incf   = Instruction(name: "incf", opcode: .incf, statusBits: .Z)
  public static let incfsz = Instruction(name: "incfsz", opcode: .incfsz)
  public static let iorwf  = Instruction(name: "iorwf", opcode: .iorwf, statusBits: .Z)
  public static let movf   = Instruction(name: "movf", opcode: .movf, statusBits: .Z)
  public static let movwf  = Instruction(name: "movwf", opcode: .movwf)
  public static let nop    = Instruction(name: "nop", opcode: .nop)
  public static let rlf    = Instruction(name: "rlf", opcode: .rlf, statusBits: .C)
  public static let rrf    = Instruction(name: "rrf", opcode: .rrf, statusBits: .C)
  public static let subwf  = Instruction(name: "subwf", opcode: .subwf, statusBits: [.C, .DC, .Z])
  public static let swapf  = Instruction(name: "swapf", opcode: .swapf)
  public static let xorwf  = Instruction(name: "xorwf", opcode: .xorwf, statusBits: .Z)

  public static let bcf    = Instruction(name: "bcf", opcode: .bcf)
  public static let bsf    = Instruction(name: "bsf", opcode: .bsf)
  public static let btfsc  = Instruction(name: "btfsc", opcode: .btfsc)
  public static let btfss  = Instruction(name: "btfss", opcode: .btfss)

  public static let andlw  = Instruction(name: "andlw", opcode: .andlw, statusBits: .Z)
  public static let call   = Instruction(name: "call", opcode: .call, cycles: 2)
  public static let clrwdt = Instruction(name: "clrwdt", opcode: .clrwdt, statusBits: [.NOT_TO, .NOT_PD])
  public static let goto   = Instruction(name: "goto", opcode: .goto, cycles: 2)
  public static let iorlw  = Instruction(name: "iorlw", opcode: .iorlw, statusBits: .Z)
  public static let movlw  = Instruction(name: "movlw", opcode: .movlw)
  public static let option = Instruction(name: "option", opcode: .option)
  public static let retlw  = Instruction(name: "retlw", opcode: .retlw, cycles: 2)
  public static let sleep  = Instruction(name: "sleep", opcode: .sleep, statusBits: [.NOT_TO, .NOT_PD])
  public static let tris   = Instruction(name: "tris", opcode: .tris)
  public static let xorlw  = Instruction(name: "xorlw", opcode: .xorlw, statusBits: .Z)
}
