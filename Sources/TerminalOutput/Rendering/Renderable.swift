import Foundation

/// Minimal interface adopted by UI building blocks to encode their state into
/// ANSI escape sequences.
public protocol Renderable {
  func render ( into builder: inout AnsiStringBuilder )
}

/// Convenience wrapper that treats an ``AnsiSequence`` as a ``Renderable`` so
/// it can be mixed with higher-level components.
public struct RenderedSequence: Renderable {
  public let sequence : AnsiSequence

  public init ( sequence: AnsiSequence ) {
    self.sequence = sequence
  }

  public func render ( into builder: inout AnsiStringBuilder ) {
    builder.append(sequence)
  }
}
