import XCTest
@testable import TerminalOutput

/// Exercises ``AnsiSequence`` convenience APIs.
final class AnsiSequenceTests: XCTestCase {
  /// Verifies that the ``content`` accessor mirrors the stored raw value.
  func testContentReturnsStoredRawValue () {
    let expected = "\u{001B}[0m"
    let sequence = AnsiSequence ( rawValue: expected )

    XCTAssertEqual ( sequence.content, expected )
  }
}
