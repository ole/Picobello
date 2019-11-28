import Basic
import Foundation
import HexHexHex
import Picobello
import SPMUtility

let executableName = CommandLine.arguments.first!

// MARK: - Configure command line options
let main = ArgumentParser(usage: "<command>", overview: "PIC instruction set assembler")
let versionFlag = main.add(
  option: "--version",
  shortName: "-v",
  kind: Bool.self,
  usage: "Print version information and exit")

let disassembleCommand = "disassemble"
let disassemble = main.add(
  subparser: disassembleCommand,
  usage: "[flag] <FILE> | --sample",
  overview: "Disassemble a .hex file")
let disassembleInputFile = disassemble.add(
  positional: "FILE",
  kind: PathArgument.self,
  optional: true,
  usage: "The .hex file to disassemble")
let disassembleSampleFile = disassemble.add(
  option: "--sample",
  kind: Bool.self,
  usage: "Disassemble a sample .hex file; useful for testing if you have no .hex file at hand")

// MARK: - Main program
do {
  let arguments = try main.parse(Array(CommandLine.arguments.dropFirst()))

  let shouldPrintVersion = arguments.get(versionFlag) ?? false
  guard !shouldPrintVersion else {
    stderrStream <<< executableName <<< " version " <<< Picobello.version <<< "\n"
    exit(.success)
  }

  switch arguments.subparser(main) {
  case disassembleCommand?:
    let hexFile: HEXFile
    let shouldUseSampleFile = arguments.get(disassembleSampleFile) ?? false
    if shouldUseSampleFile {
      hexFile = try HEXFile(text: sampleHEXFileContents)
    } else {
      guard let inputFile = arguments.get(disassembleInputFile) else {
        disassemble.printUsage(on: stderrStream)
        exit(.success)
      }
      let hexData = try Data(contentsOf: inputFile.path.asURL)
      hexFile = try HEXFile(bytes: hexData)
    }
    let program = try Program(file: hexFile)
    debugPrint(program)

  default:
    // No command passed on CLI. Print help.
    main.printUsage(on: stderrStream)
  }
} catch {
  stderrStream <<< error.localizedDescription <<< "\n"
  exit(.genericFailure)
}
