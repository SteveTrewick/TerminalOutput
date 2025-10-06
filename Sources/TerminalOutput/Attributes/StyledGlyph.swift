import Foundation

/// Styled wrapper around a single ``UnicodeScalar`` together with optional
/// colour information.  ``StyledGlyph`` is the primitive renderable that higher
/// level widgets can use when they need to emit individual characters with
/// precise styling.
public struct StyledGlyph: Renderable {
  public let scalar     : UnicodeScalar
  public let style      : TextStyle
  public let foreground : Color?
  public let background : Color?

  /// Creates a glyph with the provided ``scalar`` and ``TextStyle``.  Optional
  /// foreground and background colours allow callers to override palette
  /// entries on a per-character basis without altering the surrounding style.
  public init ( scalar: UnicodeScalar, style: TextStyle = .none, foreground: Color? = nil, background: Color? = nil ) {
    self.scalar     = scalar
    self.style      = style
    self.foreground = foreground
    self.background = background
  }

  /// Encodes the glyph into ANSI escape codes followed by the scalar itself.
  /// Opening and reset sequences are emitted as needed to ensure the terminal
  /// returns to a neutral state after rendering.
  public func render ( into builder: inout AnsiStringBuilder ) {
    if let sequence = style.openingSequence(foreground: foreground, background: background) {
      builder.append(sequence)
    }

    builder.append(String(Character(scalar)))

    if style.requiresReset || foreground != nil || background != nil {
      builder.append(TextStyle.resetSequence())
    }
  }
}

public extension Collection where Element == StyledGlyph {
  /// Convenience helper that renders the entire collection in order, avoiding
  /// the need for callers to loop manually.
  func render ( into builder: inout AnsiStringBuilder ) {
    for glyph in self {
      glyph.render(into: &builder)
    }
  }
}
