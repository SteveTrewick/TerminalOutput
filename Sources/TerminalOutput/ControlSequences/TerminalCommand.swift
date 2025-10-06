import Foundation

private let controlSequenceIntroducer : String = "\u{001B}["
private let operatingSystemCommand    : String = "\u{001B}]"
private let bellTermination           : String = "\u{0007}"

/// Rich representation of common terminal commands.  Each case maps to a
/// cursor movement, clearing behaviour, or mode toggle and can be converted
/// into an ``AnsiSequence`` using the ``sequence`` computed property.
public enum TerminalCommand : Equatable {
  /// Modes accepted by ``TerminalCommand.eraseDisplay(_:)``.
  public enum EraseDisplayMode : Int {
    case cursorToEnd             = 0
    case cursorToBeginning       = 1
    case entireScreen            = 2
    case entireScreenAndScrollback = 3
  }

  /// Modes accepted by ``TerminalCommand.eraseLine(_:)``.
  public enum EraseLineMode : Int {
    case cursorToEnd       = 0
    case cursorToBeginning = 1
    case entireLine        = 2
  }

  /// Screen buffers understood by ``TerminalCommand.selectScreenBuffer(_:)``.
  public enum ScreenBuffer {
    case primary
    case alternate
  }

  case cursorUp ( Int )
  case cursorDown ( Int )
  case cursorForward ( Int )
  case cursorBack ( Int )
  case cursorNextLine ( Int )
  case cursorPreviousLine ( Int )
  case cursorHorizontalAbsolute ( Int )
  case cursorPosition ( row: Int, column: Int )
  case saveCursorPosition
  case restoreCursorPosition
  case hideCursor
  case showCursor
  case eraseDisplay ( EraseDisplayMode )
  case eraseLine ( EraseLineMode )
  case scrollUp ( Int )
  case scrollDown ( Int )
  case selectScreenBuffer ( ScreenBuffer )
  case setWindowTitle ( String )

  public static var saveCursor : TerminalCommand { .saveCursorPosition }
  public static var restoreCursor : TerminalCommand { .restoreCursorPosition }
  public static var hideCursorCommand : TerminalCommand { .hideCursor }
  public static var showCursorCommand : TerminalCommand { .showCursor }
  public static var clearScreen : TerminalCommand { .eraseDisplay(.entireScreen) }
  public static var clearScrollback : TerminalCommand { .eraseDisplay(.entireScreenAndScrollback) }
  public static var clearLine : TerminalCommand { .eraseLine(.entireLine) }
  public static var usePrimaryScreenBuffer : TerminalCommand { .selectScreenBuffer(.primary) }
  public static var useAlternateScreenBuffer : TerminalCommand { .selectScreenBuffer(.alternate) }

  /// Computes the ANSI escape sequence corresponding to the command instance.
  public var sequence : AnsiSequence {
    switch self {
      case .cursorUp(let amount)                  : return csi(parameters: [normalized(amount)], terminator: "A")
      case .cursorDown(let amount)                : return csi(parameters: [normalized(amount)], terminator: "B")
      case .cursorForward(let amount)             : return csi(parameters: [normalized(amount)], terminator: "C")
      case .cursorBack(let amount)                : return csi(parameters: [normalized(amount)], terminator: "D")
      case .cursorNextLine(let amount)            : return csi(parameters: [normalized(amount)], terminator: "E")
      case .cursorPreviousLine(let amount)        : return csi(parameters: [normalized(amount)], terminator: "F")
      case .cursorHorizontalAbsolute(let column)  : return csi(parameters: [normalized(column)], terminator: "G")
      case .cursorPosition(let row, let column)   : return csi(parameters: [normalized(row), normalized(column)], terminator: "H")
      case .saveCursorPosition                    : return csi(parameters: [], terminator: "s")
      case .restoreCursorPosition                 : return csi(parameters: [], terminator: "u")
      case .hideCursor                            : return csi(parameters: ["?25"], terminator: "l")
      case .showCursor                            : return csi(parameters: ["?25"], terminator: "h")
      case .eraseDisplay(let mode)                : return csi(parameters: [String(mode.rawValue)], terminator: "J")
      case .eraseLine(let mode)                   : return csi(parameters: [String(mode.rawValue)], terminator: "K")
      case .scrollUp(let amount)                  : return csi(parameters: [normalized(amount)], terminator: "S")
      case .scrollDown(let amount)                : return csi(parameters: [normalized(amount)], terminator: "T")
      case .selectScreenBuffer(let buffer)        : return bufferSequence(buffer)
      case .setWindowTitle(let title)             : return osc(payload: "2;\(title)")
    }
  }
}

/// Clamps ``amount`` to at least one and returns the decimal representation.
private func normalized ( _ amount: Int ) -> String {
  let value = max(1, amount)
  return String(value)
}

/// Builds a CSI (Control Sequence Introducer) escape sequence using the
/// provided numeric ``parameters`` and final byte ``terminator``.
private func csi ( parameters: [String], terminator: Character ) -> AnsiSequence {
  let parameterString = parameters.isEmpty ? "" : parameters.joined(separator: ";")
  return AnsiSequence(rawValue: controlSequenceIntroducer + parameterString + String(terminator))
}

/// Builds an OSC (Operating System Command) sequence with the supplied
/// ``payload`` and bell termination.
private func osc ( payload: String ) -> AnsiSequence {
  return AnsiSequence(rawValue: operatingSystemCommand + payload + bellTermination)
}

/// Returns the control sequence that selects the requested screen ``buffer``.
private func bufferSequence ( _ buffer: TerminalCommand.ScreenBuffer ) -> AnsiSequence {
  switch buffer {
    case .primary  : return csi(parameters: ["?1049"], terminator: "l")
    case .alternate: return csi(parameters: ["?1049"], terminator: "h")
  }
}
