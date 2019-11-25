/// A single statement in a `Program`.
public struct Statement: Equatable {
  public var address: UInt8
  public var instruction: Instruction

  public init(address: UInt8, instruction: Instruction) {
    self.address = address
    self.instruction = instruction
  }
}

extension Statement: CustomStringConvertible {
  public var description: String {
    "\(address.hex(padTo: 2))h: \(instruction)"
  }
}
