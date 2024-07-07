//
//  View+FrameSize.swift
//  locarie
//
//  Created by qiuty on 07/07/2024.
//

import SwiftUI

extension View {
  func frame(size: CGFloat) -> some View {
    frame(width: size, height: size)
  }
}
