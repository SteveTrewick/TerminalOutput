import Foundation

public struct AnsiSequence : Equatable, Hashable, ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral, ExpressibleByArrayLiteral, CustomStringConvertible {
  public typealias ArrayLiteralElement = AnsiSequence

  public let rawValue : String

  public init ( _ rawValue: String ) {
    self.rawValue = rawValue
  }

  public init ( stringLiteral value: StringLiteralType ) {
    self.init(value)
  }

  public init ( extendedGraphemeClusterLiteral value: StringLiteralType ) {
    self.init(value)
  }

  public init ( unicodeScalarLiteral value: StringLiteralType ) {
    self.init(value)
  }

  public init ( arrayLiteral elements: AnsiSequence... ) {
    self.init(elements.map { $0.rawValue }.joined())
  }

  public var description : String { rawValue }

  public static func + ( lhs: AnsiSequence, rhs: AnsiSequence ) -> AnsiSequence {
    AnsiSequence(lhs.rawValue + rhs.rawValue)
  }
}

public extension AnsiSequence {
  static func from ( _ command: TerminalCommand ) -> AnsiSequence {
    command.sequence
  }

  static func from ( _ commands: [TerminalCommand] ) -> AnsiSequence {
    AnsiSequence(commands.map { $0.sequence.rawValue }.joined())
  }
}
