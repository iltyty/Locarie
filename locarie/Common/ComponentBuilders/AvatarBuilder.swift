//
//  AvatarBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func defaultAvatar(size: CGFloat) -> some View {
  Circle()
    .fill(LinearGradient(
      colors: [.locariePrimary, .locariePrimary.opacity(0.5)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ))
    .frame(width: size, height: size)
}
