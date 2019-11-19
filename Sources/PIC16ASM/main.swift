import HEXFileFormat
import PIC16

let hex = """
  :020000040000FA
  :1000000025001C0C0200080C06006306590AE306D2
  :100010000A0A0E0A3006590A3005110A3006200A6B
  :10002000590A050C3400000C3500000C3600000C99
  :100030003700200A66000A0C3309070C260003006B
  :10004000060C26000A0C33090400040C26000A0CD6
  :1000500033090400000C26000A0C33090400070CC5
  :1000600026000400030033000D0C32007100F10281
  :10007000370AF202370AF302340A0008140C24008B
  :10008000010CA0000306460AA402410A4B09FF0E18
  :100090004307570A0300140C2400040C3C00010C15
  :1000A000200243070008A402FC02500A01083004A1
  :0C00B000590A000C3000070C2600030069
  :0400BC000008000830
  :0201FE00FF0FF1
  :021FFE00EF0FE3
  :00000001FF
  """
let hexFile = try HEXFile(text: hex)
let program = try Program(file: hexFile)
debugPrint(program)
