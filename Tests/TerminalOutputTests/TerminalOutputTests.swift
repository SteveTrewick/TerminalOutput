import XCTest
@testable import TerminalOutput

final class TerminalOutputTests: XCTestCase {
  func testStyledGlyphRendersBoldA () throws {
    guard let scalar = "A".unicodeScalars.first else {
      XCTFail("Missing scalar")
      return
    }

    var builder = AnsiStringBuilder()
    let glyph   = StyledGlyph(scalar: scalar, style: [.bold])

    glyph.render(into: &builder)

    XCTAssertEqual(builder.asString(), "\u{001B}[1mA\u{001B}[0m")
  }

  func testFlowControlStrategyChunksData () throws {
    let strategy = FlowControlStrategy(chunkSize: 4, microPause: 0, flushEachChunk: true)
    var chunks   = [String]()
    var flushes  = 0

    try strategy.write(
      data   : Data("abcdefgh".utf8),
      using  : { chunk in
        guard let string = String(data: chunk, encoding: .utf8) else {
          XCTFail("Invalid chunk encoding")
          return
        }
        chunks.append(string)
      },
      flusher: { flushes += 1 }
    )

    XCTAssertEqual(chunks, ["abcd", "efgh"])
    XCTAssertEqual(flushes, 2)
  }

  func testTerminalSendsRenderablePayload () throws {
    let connection = MockConnection()
    let terminal   = Terminal(connection: connection)
    let glyph      = StyledGlyph(scalar: "Z".unicodeScalars.first!, style: [.underline])

    try terminal.send(glyph)

    XCTAssertEqual(connection.payloads.count, 1)
    XCTAssertEqual(connection.payloads.first.flatMap { String(data: $0, encoding: .utf8) }, "\u{001B}[4mZ\u{001B}[0m")
  }
}

private final class MockConnection: TerminalConnection {
  var payloads  : [Data] = []
  var flushes  : Int    = 0

  func write ( data: Data ) throws {
    payloads.append(data)
  }

  func flush () throws {
    flushes += 1
  }
}
