import Foundation

/// Legacy convenience namespace offering a handful of prebuilt control
/// sequences.  New code should consider working directly with ``TerminalCommand``
/// or ``CSI`` for greater flexibility, but the helpers remain handy for quick
/// scripts.
public enum TerminalCommands {
  /// Returns the ANSI escape sequence that clears the entire screen.
  public static func clearScreen () -> AnsiSequence {
    return CSI.eraseInDisplay(.entireScreen)
  }

  /// Returns the sequence that clears the current line.
  public static func clearLine () -> AnsiSequence {
    return CSI.eraseInLine(.entireLine)
  }

  /// Moves the cursor to the specified ``row`` and ``column``.
  public static func moveCursor ( row: Int, column: Int ) -> AnsiSequence {
    return CSI.cursorPosition(row: row, column: column)
  }

  /// Hides the terminal cursor.
  public static func hideCursor () -> AnsiSequence {
    return CSI.hideCursor()
  }

  /// Shows the terminal cursor if previously hidden.
  public static func showCursor () -> AnsiSequence {
    return CSI.showCursor()
  }

  /// Switches to the alternate screen buffer.
  public static func useAlternateBuffer () -> AnsiSequence {
    return CSI.useAlternateBuffer()
  }

  /// Returns to the primary screen buffer.
  public static func usePrimaryBuffer () -> AnsiSequence {
    return CSI.usePrimaryBuffer()
  }
}
