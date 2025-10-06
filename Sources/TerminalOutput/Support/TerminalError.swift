import Foundation

/// Errors surfaced by ``TerminalConnection`` implementations.  We bubble the
/// ``errno`` value to aid debugging and for callers that wish to branch on the
/// underlying POSIX failure.
public enum TerminalError: Error {
  case writeFailed ( errno: Int32 )
  case flushFailed ( errno: Int32 )
}
