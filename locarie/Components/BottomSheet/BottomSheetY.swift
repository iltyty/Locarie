//
//  BottomSheetY.swift
//  locarie
//
//  Created by qiuty on 17/06/2024.
//
import SwiftUI

struct BottomSheetY: PreferenceKey {
  typealias Value = CGFloat

  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
