//
//  BottomSheet+BottomSheetDetent.swift
//  locarie
//
//  Created by qiuty on 16/01/2024.
//

import Foundation

extension BottomSheet {
  enum BottomSheetDetent {
    case minimum
    case medium
    case large
    case fraction(CGFloat)
    case absoluteTop(CGFloat)
    case absoluteBottom(CGFloat)

    func getOffset(screenHeight height: CGFloat) -> CGFloat {
      switch self {
      case .minimum:
        return maxOffset(screenHeight: height)
      case .medium:
        return height / 2
      case .large:
        return 0
      case let .fraction(value):
        if value > 0, value <= 1 {
          return height * value
        } else {
          return 0
        }
      case let .absoluteTop(value):
        return min(max(0, value), maxOffset(screenHeight: height))
      case let .absoluteBottom(value):
        let maxOffset = maxOffset(screenHeight: height)
        return max(0, min(maxOffset, maxOffset - value))
      }
    }

    private func maxOffset(screenHeight height: CGFloat) -> CGFloat {
      height - BottomSheetConstants.handlerPaddingTop - 60
    }
  }
}
