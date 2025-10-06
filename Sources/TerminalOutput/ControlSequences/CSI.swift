import Foundation

public enum CSI {
  public static func cursorPosition ( row: Int, column: Int ) -> AnsiSequence {
    return wrap(parameters: [row, column], final: "H")
  }

  public static func cursorUp ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "A")
  }

  public static func cursorDown ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "B")
  }

  public static func cursorForward ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "C")
  }

  public static func cursorBackward ( _ count: Int = 1 ) -> AnsiSequence {
    return wrap(parameters: [count], final: "D")
  }

  public static func eraseInDisplay ( _ mode: EraseInDisplay = .entireScreen ) -> AnsiSequence {
    return wrap(parameters: [mode.rawValue], final: "J")
  }

  public static func eraseInLine ( _ mode: EraseInLine = .cursorToEnd ) -> AnsiSequence {
    return wrap(parameters: [mode.rawValue], final: "K")
  }

  public static func hideCursor () -> AnsiSequence {
    return wrap(rawCommand: "?25l")
  }

  public static func showCursor () -> AnsiSequence {
    return wrap(rawCommand: "?25h")
  }

  public static func useAlternateBuffer () -> AnsiSequence {
    return wrap(rawCommand: "?1049h")
  }

  public static func usePrimaryBuffer () -> AnsiSequence {
    return wrap(rawCommand: "?1049l")
  }

  private static func wrap ( parameters: [Int], final: String ) -> AnsiSequence {
    let body = parameters.isEmpty ? final : "\(parameters.map(String.init).joined(separator: ";"))\(final)"
    return wrap(rawCommand: body)
  }

  private static func wrap ( rawCommand: String ) -> AnsiSequence {
    return AnsiSequence(rawValue: "\u{001B}[\(rawCommand)")
  }

  public enum EraseInDisplay: Int {
    case cursorToEnd   = 0
    case cursorToStart = 1
    case entireScreen  = 2
  }

  public enum EraseInLine: Int {
    case cursorToEnd   = 0
    case cursorToStart = 1
    case entireLine    = 2
  }
}
