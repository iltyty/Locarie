//
//  Color+Extensions.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Foundation
import SwiftUI

extension Color {
  static let mapMarkerOrange = Color(hex: 0xFF571B)

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
