import Foundation

/// Describes the visible portion of the terminal measured in rows and columns.
/// ``Viewport`` offers helpers for clamping coordinates so renderers can stay
/// within the current bounds when positioning content.
public struct Viewport {
  public let rows    : Int
  public let columns : Int

  /// Creates a viewport with explicit ``rows`` and ``columns``.
  public init ( rows: Int, columns: Int ) {
    self.rows    = rows
    self.columns = columns
  }

  /// Clamps ``value`` to the valid row range ``1 ... rows``.
  public func clampedRow ( _ value: Int ) -> Int {
    return max(1, min(rows, value))
  }

  /// Clamps ``value`` to the valid column range ``1 ... columns``.
  public func clampedColumn ( _ value: Int ) -> Int {
    return max(1, min(columns, value))
  }
}
