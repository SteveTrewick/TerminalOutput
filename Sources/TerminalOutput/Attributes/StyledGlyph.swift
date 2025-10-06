import Foundation

public struct StyledGlyph: Renderable {
  public let scalar     : UnicodeScalar
  public let style      : TextStyle
  public let foreground : Color?
  public let background : Color?

  public init ( scalar: UnicodeScalar, style: TextStyle = .none, foreground: Color? = nil, background: Color? = nil ) {
    self.scalar     = scalar
    self.style      = style
    self.foreground = foreground
    self.background = background
  }

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
  func render ( into builder: inout AnsiStringBuilder ) {
    for glyph in self {
      glyph.render(into: &builder)
    }
  }
}
