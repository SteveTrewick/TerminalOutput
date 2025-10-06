import XCTest
@testable import TerminalOutput

final class TerminalCommandTests : XCTestCase {
  func testCursorMovementSequences () {
    let commands : [TerminalCommand] = [
      .cursorUp(3),
      .cursorDown(2),
      .cursorForward(5),
      .cursorBack(4),
      .cursorNextLine(6),
      .cursorPreviousLine(7),
      .cursorHorizontalAbsolute(12),
      .cursorPosition(row: 9, column: 3)
    ]

    let sequences = commands.map { $0.sequence.rawValue }

    XCTAssertEqual(sequences[0], "\u{001B}[3A")
    XCTAssertEqual(sequences[1], "\u{001B}[2B")
    XCTAssertEqual(sequences[2], "\u{001B}[5C")
    XCTAssertEqual(sequences[3], "\u{001B}[4D")
    XCTAssertEqual(sequences[4], "\u{001B}[6E")
    XCTAssertEqual(sequences[5], "\u{001B}[7F")
    XCTAssertEqual(sequences[6], "\u{001B}[12G")
    XCTAssertEqual(sequences[7], "\u{001B}[9;3H")
  }

  func testCursorVisibilityAndPersistenceCommands () {
    XCTAssertEqual(TerminalCommand.saveCursor.sequence.rawValue, "\u{001B}[s")
    XCTAssertEqual(TerminalCommand.restoreCursor.sequence.rawValue, "\u{001B}[u")
    XCTAssertEqual(TerminalCommand.hideCursorCommand.sequence.rawValue, "\u{001B}[?25l")
    XCTAssertEqual(TerminalCommand.showCursorCommand.sequence.rawValue, "\u{001B}[?25h")
  }

  func testEraseAndScrollCommands () {
    XCTAssertEqual(TerminalCommand.clearScreen.sequence.rawValue, "\u{001B}[2J")
    XCTAssertEqual(TerminalCommand.clearScrollback.sequence.rawValue, "\u{001B}[3J")
    XCTAssertEqual(TerminalCommand.clearLine.sequence.rawValue, "\u{001B}[2K")
    XCTAssertEqual(TerminalCommand.scrollUp(10).sequence.rawValue, "\u{001B}[10S")
    XCTAssertEqual(TerminalCommand.scrollDown(4).sequence.rawValue, "\u{001B}[4T")
  }

  func testBufferSelection () {
    XCTAssertEqual(TerminalCommand.useAlternateScreenBuffer.sequence.rawValue, "\u{001B}[?1049h")
    XCTAssertEqual(TerminalCommand.usePrimaryScreenBuffer.sequence.rawValue, "\u{001B}[?1049l")
  }

  func testWindowTitle () {
    XCTAssertEqual(TerminalCommand.setWindowTitle("Hello").sequence.rawValue, "\u{001B}]2;Hello\u{0007}")
  }

  func testAnsiSequenceBridging () {
    let combined = AnsiSequence.from([
      .cursorUp(1),
      .cursorDown(1),
      .setWindowTitle("Combined")
    ])

    XCTAssertEqual(combined.rawValue, "\u{001B}[1A\u{001B}[1B\u{001B}]2;Combined\u{0007}")
  }
}
