import Foundation
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

/// Encapsulates how the terminal connection should pace bytes to the underlying
/// file descriptor so that xterm (and other emulators) are not overwhelmed.
///
/// The strategy works in three dimensions:
/// - **chunkSize**: the maximum slice of bytes we attempt to write in a single
///   system call.  Smaller chunks reduce the risk of filling the terminal's
///   output buffer at the cost of more syscalls.
/// - **microPause**: an optional pause, expressed in microseconds, introduced
///   between chunk writes.  This mirrors XON/XOFF style pacing without needing
///   explicit terminal negotiation.
/// - **flushEachChunk**: controls whether the strategy should ask the
///   connection to drain the file descriptor after each chunk, ensuring bytes
///   are visible before the next write is attempted.
public struct FlowControlStrategy {
  /// Upper bound on the number of bytes written per pass.  We clamp the value
  /// to at least 1 so callers cannot create a zero-byte loop accidentally.
  public let chunkSize      : Int

  /// Microsecond delay injected between chunk writes.  A value of zero means
  /// "do not sleep".
  public let microPause     : useconds_t

  /// Indicates whether the caller supplied flusher should be invoked after
  /// every chunk.  This is useful when the descriptor is backed by a pty that
  /// needs explicit drain calls.
  public let flushEachChunk : Bool

  /// Creates a strategy with explicit pacing parameters.  The chunk size is
  /// bounded to be at least one byte so the loop in ``write`` always makes
  /// forward progress.
  public init ( chunkSize: Int, microPause: useconds_t, flushEachChunk: Bool ) {
    self.chunkSize      = max(1, chunkSize)
    self.microPause     = microPause
    self.flushEachChunk = flushEachChunk
  }

  /// Convenience strategy that attempts to write the payload in a single pass
  /// while still honouring explicit flush requests.  Useful when the caller has
  /// pre-sized data known to be safe for immediate emission.
  public static let immediate : FlowControlStrategy = FlowControlStrategy(chunkSize: Int.max, microPause: 0, flushEachChunk: true)

  /// Factory for chunked pacing.  The defaults favour safety by flushing after
  /// each write, but callers can opt-out when the downstream buffer is known to
  /// be resilient.
  public static func chunked ( size: Int, pauseMicroseconds: useconds_t, flushEachChunk: Bool = true ) -> FlowControlStrategy {
    return FlowControlStrategy(chunkSize: size, microPause: pauseMicroseconds, flushEachChunk: flushEachChunk)
  }

  /// Writes ``data`` using the supplied ``writer`` closure in one or more
  /// chunks, invoking ``flusher`` and ``usleep`` according to the stored
  /// parameters.
  ///
  /// - Parameters:
  ///   - data: The bytes to emit.  Empty buffers return immediately.
  ///   - writer: Closure responsible for the actual write call (e.g. ``write``)
  ///     to the file descriptor.
  ///   - flusher: Closure performing the drain (e.g. ``tcdrain``).  It is only
  ///     invoked when ``flushEachChunk`` is ``true``.
  public func write ( data: Data, using writer: (Data) throws -> Void, flusher: () throws -> Void ) throws {
    if data.isEmpty { return }

    if chunkSize >= data.count {
      try writer(data)
      if flushEachChunk { try flusher() }
      return
    }

    var index = data.startIndex

    while index < data.endIndex {
      let upper = data.index(index, offsetBy: chunkSize, limitedBy: data.endIndex) ?? data.endIndex
      let view  = data[index ..< upper]

      try writer(Data(view))

      if flushEachChunk {
        try flusher()
      }

      if microPause > 0 {
        usleep(microPause)
      }

      index = upper
    }
  }
}
