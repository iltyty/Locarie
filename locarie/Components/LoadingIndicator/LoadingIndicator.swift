//
//  LoadingIndicator.swift
//  locarie
//
//  Created by qiuty on 11/04/2024.
//

import SwiftUI
import UIKit

struct LoadingIndicator: View {
  @State private var angle: Double = 0

  var body: some View {
    Circle()
      .trim(from: Constants.startFraction, to: Constants.endFraction)
      .stroke(Constants.lineColor, lineWidth: Constants.lineWidth)
      .frame(size: Constants.size)
      .rotationEffect(Angle(degrees: angle))
      .onAppear {
        withAnimation(.linear(
          duration: Constants.duration
        ).repeatForever(autoreverses: false)) {
          angle = 360
        }
      }
  }
}

private enum Constants {
  static let size: CGFloat = 50
  static let duration: CGFloat = 1.5
  static let lineWidth: CGFloat = 3
  static let startFraction: Double = 0
  static let endFraction: Double = 0.8
  static let lineColor: Color = .init(hex: 0xFF5800)
}
