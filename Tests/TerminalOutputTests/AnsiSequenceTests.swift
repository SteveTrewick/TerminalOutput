import XCTest
@testable import TerminalOutput

final class AnsiSequenceTests: XCTestCase {
  func testContentReturnsStoredRawValue () {
    let expected = "\u{001B}[0m"
    let sequence = AnsiSequence ( rawValue: expected )

    XCTAssertEqual ( sequence.content, expected )
  }
}
