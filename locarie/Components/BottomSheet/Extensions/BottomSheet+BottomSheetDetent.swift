//
//  BottomSheet+BottomSheetDetent.swift
//  locarie
//
//  Created by qiuty on 16/01/2024.
//

import Foundation

enum BottomSheetDetent: Equatable {
  case minimum
  case medium
  case large
  case fraction(CGFloat)
  case absoluteTop(CGFloat)
  case absoluteBottom(CGFloat)

  func getOffset(contentHeight height: CGFloat) -> CGFloat {
    switch self {
    case .minimum:
      height
    case .medium:
      height / 2
    case .large:
      0
    case let .fraction(value):
      if value > 0, value <= 1 {
        height * value
      } else {
        0
      }
    case let .absoluteTop(value):
      min(max(0, value), height)
    case let .absoluteBottom(value):
      max(0, min(height, height - value))
    }
  }
}
