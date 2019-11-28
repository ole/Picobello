import Basic
import SPMLibc

enum ExitCode: Int32 {
  case success = 0
  case genericFailure = 1
}

func exit(_ exitCode: ExitCode) -> Never {
  stdoutStream.flush()
  stderrStream.flush()
  SPMLibc.exit(exitCode.rawValue)
}
