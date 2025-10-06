public struct AnsiSequence : RawRepresentable, ExpressibleByStringLiteral, Equatable {
  public typealias StringLiteralType = String

  public let rawValue : String
  public var content  : String { rawValue }

  public init ( rawValue: String ) {
    self.rawValue = rawValue
  }

  public init ( stringLiteral value: StringLiteralType ) {
    self.rawValue = value
  }

  public static func from ( _ commands: [TerminalCommand] ) -> AnsiSequence {
    let combined = commands.map { $0.sequence.rawValue }.joined()
    return AnsiSequence(rawValue: combined)
  }
}
