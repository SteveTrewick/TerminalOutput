import Foundation

public struct Viewport {
  public let rows    : Int
  public let columns : Int

  public init ( rows: Int, columns: Int ) {
    self.rows    = rows
    self.columns = columns
  }

  public func clampedRow ( _ value: Int ) -> Int {
    return max(1, min(rows, value))
  }

  public func clampedColumn ( _ value: Int ) -> Int {
    return max(1, min(columns, value))
  }
}
