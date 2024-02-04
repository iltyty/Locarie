//
//  CapsuleButton.swift
//  locarie
//
//  Created by qiuty on 04/02/2024.
//

import SwiftUI

struct CapsuleButton<Content: View>: View {
  let content: () -> Content

  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  var body: some View {
    content()
      .padding(.horizontal)
      .background(background)
  }

  private var background: some View {
    Capsule()
      .fill(.background)
      .frame(height: Constants.height)
      .shadow(radius: Constants.shadow)
  }
}

private enum Constants {
  static let height = 48.0
  static let shadow = 2.0
}

#Preview {
  ZStack {
    Color.red
    CapsuleButton {
      Label("London", systemImage: "map")
    }
  }
}
