import HexHexHex

public struct Program {
  public var records: [Record]

  public init(file: HEXFile) throws {
    let parser = PICHEXParser(hexRecords: file.records)
    self.records = try parser.parse()
  }
}

extension Program {
  // TODO: Find a better name
  public enum Record: Equatable {
    case config(UInt16)
    case statement(Statement)
  }
}

extension Program: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    "Program (\(records.count) records)"
  }

  public var debugDescription: String {
    """
    Program (\(records.count) records)
    \(records.map(String.init(describing:)).joined(separator: "\n"))
    """
  }
}
