import Foundation
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

/// Abstraction describing the minimal surface required by ``Terminal`` for
/// output.  Connections accept raw ``Data`` payloads and can be asked to flush
/// any buffered bytes.
public protocol TerminalConnection {
  /// Writes ``data`` to the underlying destination.
  func write ( data: Data ) throws

  /// Flushes pending bytes, ensuring they reach the terminal.
  func flush () throws
}

/// Concrete ``TerminalConnection`` backed by a ``FileHandle`` (typically
/// ``stdout`` or a pseudo-terminal).  The connection delegates pacing to a
/// ``FlowControlStrategy`` so terminals with fragile buffers do not garble
/// output.
public final class FileHandleTerminalConnection: TerminalConnection {
  private let outputHandle : FileHandle
  private let strategy     : FlowControlStrategy

  /// Creates a connection writing to ``output`` using the supplied pacing
  /// ``strategy``.
  public init ( output: FileHandle = FileHandle.standardOutput, strategy: FlowControlStrategy = .immediate ) {
    self.outputHandle = output
    self.strategy     = strategy
  }

  /// Writes ``data`` by delegating to the configured ``FlowControlStrategy``.
  public func write ( data: Data ) throws {
    try strategy.write(
      data   : data,
      using  : { [outputHandle] chunk in try performWrite(chunk, to: outputHandle) },
      flusher: { [outputHandle] in try performFlush(of: outputHandle) }
    )
  }

  /// Flushes the underlying ``FileHandle``.
  public func flush () throws {
    try performFlush(of: outputHandle)
  }
}

/// Performs a blocking write of ``data`` to ``handle``, looping until all bytes
/// have been accepted or an error is raised by the underlying descriptor.
/// Throws ``TerminalError.writeFailed`` when the system call fails.
private func performWrite ( _ data: Data, to handle: FileHandle ) throws {
  if data.isEmpty { return }

  try data.withUnsafeBytes { pointer in
    guard let base = pointer.baseAddress else { return }

    var remaining = pointer.count
    var current   = base

    while remaining > 0 {
      let written = systemWrite(handle.fileDescriptor, current, remaining)

      if written < 0 {
        throw TerminalError.writeFailed(errno: errno)
      }

      let advanced = Int(written)

      remaining -= advanced
      current    = current.advanced(by: advanced)
    }
  }
}

/// Asks the descriptor backing ``handle`` to drain pending bytes.  On macOS we
/// use ``tcdrain`` while Linux falls back to ``fsync`` which, in practice, is
/// the closest portable option exposed in Glibc.
/// Throws ``TerminalError.flushFailed`` when draining fails.
private func performFlush ( of handle: FileHandle ) throws {
  if systemDrain(handle.fileDescriptor) != 0 {
    throw TerminalError.flushFailed(errno: errno)
  }
}

/// Thin wrapper over ``write`` so the Linux and Darwin code paths remain tidy.
private func systemWrite ( _ descriptor: Int32, _ buffer: UnsafeRawPointer, _ size: Int ) -> ssize_t {
  #if canImport(Darwin)
  return Darwin.write(descriptor, buffer, size)
  #else
  return Glibc.write(descriptor, buffer, size)
  #endif
}

/// Invokes the best available drain call for the target platform.
private func systemDrain ( _ descriptor: Int32 ) -> Int32 {
  #if canImport(Darwin)
  return tcdrain(descriptor)
  #else
  return Glibc.fsync(descriptor)
  #endif
}
