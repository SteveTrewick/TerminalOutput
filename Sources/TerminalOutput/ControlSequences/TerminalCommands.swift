import Foundation

public enum TerminalCommands {
  public static func clearScreen () -> AnsiSequence {
    return CSI.eraseInDisplay(.entireScreen)
  }

  public static func clearLine () -> AnsiSequence {
    return CSI.eraseInLine(.entireLine)
  }

  public static func moveCursor ( row: Int, column: Int ) -> AnsiSequence {
    return CSI.cursorPosition(row: row, column: column)
  }

  public static func hideCursor () -> AnsiSequence {
    return CSI.hideCursor()
  }

  public static func showCursor () -> AnsiSequence {
    return CSI.showCursor()
  }

  public static func useAlternateBuffer () -> AnsiSequence {
    return CSI.useAlternateBuffer()
  }

  public static func usePrimaryBuffer () -> AnsiSequence {
    return CSI.usePrimaryBuffer()
  }
}
