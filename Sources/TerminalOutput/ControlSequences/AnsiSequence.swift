import Foundation

public struct AnsiSequence : Equatable, Hashable, ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = UInt8

  public let bytes : [UInt8]

  public init ( bytes: [UInt8] ) {
    self.bytes = bytes
  }

  public init ( arrayLiteral elements: UInt8... ) {
    self.bytes = elements
  }

  public init ( stringLiteral value: String ) {
    self.bytes = Array(value.utf8)
  }
}
