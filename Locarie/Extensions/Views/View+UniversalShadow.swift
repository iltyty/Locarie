//
//  View+UniversalShadow.swift
//  locarie
//
//  Created by qiuty on 07/07/2024.
//

import SwiftUI

extension View {
  func universalShadow() -> some View {
    shadow(color: LocarieColor.black.opacity(0.2), radius: 2, x: 0.25, y: 0.25)
  }
}
