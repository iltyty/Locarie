//
//  Color+Hex.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Foundation
import SwiftUI

extension Color {
  static let locariePrimary = Color(hex: 0xFF5800)

  init(hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 08) & 0xFF) / 255,
      blue: Double((hex >> 00) & 0xFF) / 255,
      opacity: alpha
    )
  }
}
