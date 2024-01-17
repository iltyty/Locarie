//
//  BottomSheet+GetOffsetY.swift
//  locarie
//
//  Created by qiuty on 16/01/2024.
//

import Foundation

extension BottomSheet {
  func getOffsetY() -> CGFloat {
    let currentOffset = translation.height + offsetY
    var minDiffIndex = -1
    var minDiff = CGFloat.greatestFiniteMagnitude

    let detentOffsets = detents.map { $0.getOffset(screenHeight: screenHeight) }
    detentOffsets.enumerated().forEach { index, offset in
      let diff = abs(offset - currentOffset)
      if diff < minDiff {
        minDiff = diff
        minDiffIndex = index
      }
    }
    return detentOffsets[minDiffIndex]
  }
}
