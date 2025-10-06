import Foundation

/// Represents the stylistic attributes applied to text.  The option-set form
/// mirrors the ANSI SGR flags and enables convenient combination of effects.
public struct TextStyle: OptionSet {
  public let rawValue : UInt16

  public init ( rawValue: UInt16 ) {
    self.rawValue = rawValue
  }

  public static let none          : TextStyle = []
  public static let bold          : TextStyle = TextStyle(rawValue: 1 << 0)
  public static let dim           : TextStyle = TextStyle(rawValue: 1 << 1)
  public static let italic        : TextStyle = TextStyle(rawValue: 1 << 2)
  public static let underline     : TextStyle = TextStyle(rawValue: 1 << 3)
  public static let blink         : TextStyle = TextStyle(rawValue: 1 << 4)
  public static let inverse       : TextStyle = TextStyle(rawValue: 1 << 5)
  public static let hidden        : TextStyle = TextStyle(rawValue: 1 << 6)
  public static let strikethrough : TextStyle = TextStyle(rawValue: 1 << 7)

  /// Returns an ANSI SGR sequence opening the styles represented by ``self``
  /// plus optional foreground/background colours.  When no attributes are set
  /// the method returns ``nil`` to avoid emitting empty control codes.
  public func openingSequence ( foreground: Color?, background: Color? ) -> AnsiSequence? {
    var codes = [String]()

    if contains(.bold) { codes.append("1") }
    if contains(.dim) { codes.append("2") }
    if contains(.italic) { codes.append("3") }
    if contains(.underline) { codes.append("4") }
    if contains(.blink) { codes.append("5") }
    if contains(.inverse) { codes.append("7") }
    if contains(.hidden) { codes.append("8") }
    if contains(.strikethrough) { codes.append("9") }
    if let foreground = foreground { codes.append(foreground.foregroundParameter()) }
    if let background = background { codes.append(background.backgroundParameter()) }

    guard codes.isEmpty == false else { return nil }

    return AnsiSequence(rawValue: "\u{001B}[\(codes.joined(separator: ";"))m")
  }

  /// Returns the canonical reset sequence ``ESC[0m``.
  public static func resetSequence () -> AnsiSequence {
    return AnsiSequence(rawValue: "\u{001B}[0m")
  }

  /// Indicates whether a reset sequence is required after rendering the style.
  public var requiresReset : Bool {
    return isEmpty == false
  }
}

/// 256-colour palette index used by ``TextStyle`` to emit extended colour SGR
/// sequences.
public struct Color {
  public let index : UInt8

  public init ( index: UInt8 ) {
    self.index = index
  }

  public static let black   : Color = Color(index: 0)
  public static let red     : Color = Color(index: 1)
  public static let green   : Color = Color(index: 2)
  public static let yellow  : Color = Color(index: 3)
  public static let blue    : Color = Color(index: 4)
  public static let magenta : Color = Color(index: 5)
  public static let cyan    : Color = Color(index: 6)
  public static let white   : Color = Color(index: 7)

  /// Returns the SGR parameter enabling this colour as the foreground.
  public func foregroundParameter () -> String {
    return "38;5;\(index)"
  }

  /// Returns the SGR parameter enabling this colour as the background.
  public func backgroundParameter () -> String {
    return "48;5;\(index)"
  }
}
