import Foundation

/// Minimal interface adopted by UI building blocks to encode their state into
/// ANSI escape sequences.
public protocol Renderable {
  /// Encodes the object into the supplied ``AnsiStringBuilder``.
  func render ( into builder: inout AnsiStringBuilder )
}

/// Convenience wrapper that treats an ``AnsiSequence`` as a ``Renderable`` so
/// it can be mixed with higher-level components.
public struct RenderedSequence: Renderable {
  public let sequence : AnsiSequence

  /// Wraps the provided ``sequence`` so it can participate in higher level
  /// rendering pipelines without additional adapters.
  public init ( sequence: AnsiSequence ) {
    self.sequence = sequence
  }

  /// Appends the stored sequence directly to the builder.
  public func render ( into builder: inout AnsiStringBuilder ) {
    builder.append(sequence)
  }
}
