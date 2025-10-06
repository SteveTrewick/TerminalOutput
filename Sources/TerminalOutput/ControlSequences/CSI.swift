import Foundation

/// Namespace mirroring Control Sequence Introducer commands.  Each helper
/// constructs the corresponding ``AnsiSequence`` while handling parameter
/// formatting automatically.
public enum CSI {
  /// Moves the cursor to ``row`` and ``column`` (1-based).
  public static func cursorPosition ( row: Int, column: Int ) -> AnsiSequence {
    return wrap(parameters: [row, column], final: "H")
  }

  /// Moves the cursor up by ``count`` cells (default 1).
  public static func cursorUp ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "A")
  }

  /// Moves the cursor down by ``count`` cells (default 1).
  public static func cursorDown ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "B")
  }

  /// Moves the cursor forward (right) by ``count`` cells (default 1).
  public static func cursorForward ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "C")
  }

  /// Moves the cursor backward (left) by ``count`` cells (default 1).
  public static func cursorBackward ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "D")
  }

  /// Clears parts of the display according to ``mode``.
  public static func eraseInDisplay ( _ mode: EraseInDisplay = .entireScreen ) -> AnsiSequence {
    return wrap(parameters: [mode.rawValue], final: "J")
  }

  /// Clears parts of the current line according to ``mode``.
  public static func eraseInLine ( _ mode: EraseInLine = .cursorToEnd ) -> AnsiSequence {
    return wrap(parameters: [mode.rawValue], final: "K")
  }

  /// Hides the cursor without moving it.
  public static func hideCursor () -> AnsiSequence {
    return wrap(rawCommand: "?25l")
  }

  /// Shows the cursor if hidden.
  public static func showCursor () -> AnsiSequence {
    return wrap(rawCommand: "?25h")
  }

  /// Switches to the alternate screen buffer.
  public static func useAlternateBuffer () -> AnsiSequence {
    return wrap(rawCommand: "?1049h")
  }

  /// Switches back to the primary screen buffer.
  public static func usePrimaryBuffer () -> AnsiSequence {
    return wrap(rawCommand: "?1049l")
  }

  /// Formats a CSI command composed of integer ``parameters`` followed by the
  /// ``final`` byte.
  private static func wrap ( parameters: [Int], final: String ) -> AnsiSequence {
    let body = parameters.isEmpty ? final : "\(parameters.map(String.init).joined(separator: ";"))\(final)"
    return wrap(rawCommand: body)
  }

  /// Wraps the provided ``rawCommand`` with the ESC[ introducer.
  private static func wrap ( rawCommand: String ) -> AnsiSequence {
    return AnsiSequence(rawValue: "\u{001B}[\(rawCommand)")
  }

  /// Modes supported by ``eraseInDisplay(_:)``.
  public enum EraseInDisplay: Int {
    case cursorToEnd   = 0
    case cursorToStart = 1
    case entireScreen  = 2
  }

  /// Modes supported by ``eraseInLine(_:)``.
  public enum EraseInLine: Int {
    case cursorToEnd   = 0
    case cursorToStart = 1
    case entireLine    = 2
  }
}
