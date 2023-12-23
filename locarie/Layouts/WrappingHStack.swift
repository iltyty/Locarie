//
//  WrappingHStack.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import Foundation
import SwiftUI

struct WrappingHStack: Layout {
  var vSpacing: CGFloat
  var hSpacing: CGFloat
  var alignment: TextAlignment

  init(
    vSpacing: CGFloat = 10,
    hSpacing: CGFloat = 10,
    alignment: TextAlignment = .leading
  ) {
    self.vSpacing = vSpacing
    self.hSpacing = hSpacing
    self.alignment = alignment
  }

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache _: inout ()
  ) -> CGSize {
    let rows = getRows(subviews: subviews, totalWidth: proposal.width)
    return .init(
      width: rows.map(\.width).max() ?? 0,
      height: rows.last?.viewRects.map(\.maxY).max() ?? 0
    )
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal _: ProposedViewSize,
    subviews: Subviews,
    cache _: inout ()
  ) {
    let rows = getRows(subviews: subviews, totalWidth: bounds.width)
    placeSubviewsAccordingToRows(subviews: subviews, rows: rows, in: bounds)
  }

  private func getRows(subviews: Subviews, totalWidth: CGFloat?) -> [Row] {
    guard let totalWidth, !subviews.isEmpty else {
      return []
    }
    return loopSubviewsToGetRows(
      subviews: subviews,
      totalWidth: totalWidth
    )
  }

  private func loopSubviewsToGetRows(
    subviews: Subviews,
    totalWidth: CGFloat
  ) -> [Row] {
    var rows = [Row()]
    let proposal = ProposedViewSize(width: totalWidth, height: nil)
    subviews.indices.forEach { index in
      let view = subviews[index]
      let size = view.sizeThatFits(proposal)
      let previousRect = getPreviousRect(rows: rows)
      let previousView = getPreviousView(
        rows: rows,
        subviews: subviews,
        index: index
      )
      let spacing = getHSpacing(from: previousView, to: view)

      switch shouldStartNewRow(
        maxX: previousRect.maxX,
        width: spacing + size.width,
        totalWidth: totalWidth
      ) {
      case true:
        let newY = previousRect.minY + rows.last!.height + vSpacing
        startNewRow(fromY: newY, withSize: size, rows: &rows)
      case false:
        let x = previousRect.maxX + (previousView == nil ? 0 : hSpacing)
        let y = previousRect.minY
        appendRectToCurrentRow(withX: x, withY: y, withSize: size, rows: &rows)
      }
    }
    return rows
  }

  private func getPreviousRect(rows: [Row]) -> CGRect {
    rows.last!.viewRects.last ?? .zero
  }

  private func getPreviousView(rows: [Row], subviews: Subviews, index: Int)
    -> Subviews.Element?
  {
    rows.last!.viewRects.isEmpty ? nil : subviews[index - 1]
  }

  private func getHSpacing(
    from previousView: Subviews.Element?,
    to currentView: Subviews.Element
  ) -> CGFloat {
    previousView?.spacing.distance(
      to: currentView.spacing,
      along: .horizontal
    ) ?? 0
  }

  private func shouldStartNewRow(
    maxX: CGFloat,
    width: CGFloat,
    totalWidth: CGFloat
  ) -> Bool {
    maxX + width > totalWidth
  }

  private func startNewRow(
    fromY y: CGFloat,
    withSize size: CGSize,
    rows: inout [Row]
  ) {
    let origin = CGPoint(x: 0, y: y)
    let rect = CGRect(origin: origin, size: size)
    rows.append(Row(viewRects: [rect]))
  }

  private func appendRectToCurrentRow(
    withX x: CGFloat,
    withY y: CGFloat,
    withSize size: CGSize,
    rows: inout [Row]
  ) {
    let origin = CGPoint(x: x, y: y)
    let rect = CGRect(origin: origin, size: size)
    rows[rows.count - 1].viewRects.append(rect)
  }

  private func placeSubviewsAccordingToRows(
    subviews: Subviews,
    rows: [Row],
    in bounds: CGRect
  ) {
    var index = 0
    rows.forEach { row in
      let minX = row.getMinX(in: bounds, alignment: alignment)
      row.viewRects.forEach { rect in
        let view = subviews[index]
        defer { index += 1 }
        view.place(
          at: CGPoint(x: rect.minX + minX, y: rect.minY + bounds.minY),
          proposal: .init(rect.size)
        )
      }
    }
  }

  private struct Row {
    var viewRects = [CGRect]()
    var width: CGFloat { viewRects.last?.maxX ?? 0 }
    var height: CGFloat { viewRects.map(\.height).max() ?? 0 }
    func getMinX(in bounds: CGRect, alignment: TextAlignment) -> CGFloat {
      switch alignment {
      case .leading:
        bounds.minX
      case .center:
        bounds.minX + (bounds.width - width) / 2
      case .trailing:
        bounds.maxX - width
      }
    }
  }
}
