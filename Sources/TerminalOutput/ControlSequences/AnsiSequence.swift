import Foundation

public struct AnsiSequence {
  public let rawValue : String

  public init ( rawValue: String ) {
    self.rawValue = rawValue
  }

  public func data () -> Data {
    return Data(rawValue.utf8)
  }
}
