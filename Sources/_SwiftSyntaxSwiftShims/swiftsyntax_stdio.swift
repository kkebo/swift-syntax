#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
@preconcurrency import Glibc
#endif

public var swift_syntax_stdout: UnsafeMutablePointer<FILE> { stdout }
public var swift_syntax_stdin: UnsafeMutablePointer<FILE> { stdin }
public var swift_syntax_stderr: UnsafeMutablePointer<FILE> { stderr }
