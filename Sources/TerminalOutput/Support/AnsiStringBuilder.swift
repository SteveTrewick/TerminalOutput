import Foundation

/// Lightweight helper that collects ANSI sequences and plain text into a
/// mutable ``String`` before turning the result into ``Data``.
public struct AnsiStringBuilder {
  private var storage : String

  /// Creates an empty builder ready to receive ANSI sequences and plain text.
  public init () {
    self.storage = ""
  }

  /// Appends the raw escape sequence backing ``sequence``.
  public mutating func append ( _ sequence: AnsiSequence ) {
    storage.append(sequence.rawValue)
  }

  /// Appends a chunk of plain ``text`` without additional processing.
  public mutating func append ( _ text: String ) {
    storage.append(text)
  }

  /// Returns the current buffer encoded as UTF-8 ``Data``.
  public func asData () -> Data {
    return Data(storage.utf8)
  }

  /// Provides direct access to the composed string, mainly for testing.
  public func asString () -> String {
    return storage
  }
}
