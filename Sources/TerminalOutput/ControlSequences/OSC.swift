import Foundation

/// Namespace for Operating System Command helpers.
public enum OSC {
  /// Produces the sequence that sets the terminal window title to ``title``.
  public static func setWindowTitle ( _ title: String ) -> AnsiSequence {
    return AnsiSequence(rawValue: "\u{001B}]0;\(title)\u{0007}")
  }
}
