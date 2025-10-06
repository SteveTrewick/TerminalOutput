import Foundation

public enum OSC {
  public static func setWindowTitle ( _ title: String ) -> AnsiSequence {
    return AnsiSequence(rawValue: "\u{001B}]0;\(title)\u{0007}")
  }
}
