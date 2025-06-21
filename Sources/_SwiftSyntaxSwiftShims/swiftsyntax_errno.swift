#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

public var swift_syntax_errno: Int32 { errno }
