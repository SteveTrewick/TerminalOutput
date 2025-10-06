import Foundation

/// Facade that marshals renderables and raw text to a ``TerminalConnection``.
/// All helpers ultimately convert the content into UTF-8 ``Data`` using an
/// ``AnsiStringBuilder`` before writing to the connection.
public struct Terminal {
  /// Destination responsible for the actual IO.  A custom connection lets
  /// callers plug in test doubles or alternate pacing behaviour.
  public let connection : TerminalConnection

  public init ( connection: TerminalConnection ) {
    self.connection = connection
  }

  /// Renders a single ``Renderable`` into ANSI escape codes and sends it.
  public func send ( _ renderable: Renderable ) throws {
    var builder = AnsiStringBuilder()
    renderable.render(into: &builder)
    try connection.write(data: builder.asData())
  }

  /// Renders an array of renderables in order.  This is convenient for batching
  /// related UI elements without forcing the caller to manage a shared builder.
  public func send ( _ renderables: [Renderable] ) throws {
    var builder = AnsiStringBuilder()

    for renderable in renderables {
      renderable.render(into: &builder)
    }

    try connection.write(data: builder.asData())
  }

  /// Sends raw text directly.  Useful for tests or for quick prototypes that do
  /// not yet implement ``Renderable``.
  public func send ( _ text: String ) throws {
    var builder = AnsiStringBuilder()
    builder.append(text)
    try connection.write(data: builder.asData())
  }

  /// Asks the underlying connection to flush any buffered bytes.
  public func flush () throws {
    try connection.flush()
  }
}

public extension Terminal {
  /// Sends a pre-constructed list of ANSI sequences without building an
  /// intermediate ``Renderable`` wrapper.
  func perform ( _ sequences: [AnsiSequence] ) throws {
    var builder = AnsiStringBuilder()

    for sequence in sequences {
      builder.append(sequence)
    }

    try connection.write(data: builder.asData())
  }
}
