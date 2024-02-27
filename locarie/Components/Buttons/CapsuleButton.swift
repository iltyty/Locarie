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
      .frame(height: Constants.height)
      .background(background)
  }

  private var background: some View {
    Capsule()
      .fill(.background)
      .stroke(LocarieColor.lightGray)
  }
}

private enum Constants {
  static let height = 40.0
}

#Preview {
  ZStack {
    Color.pink
    CapsuleButton {
      Label("London", systemImage: "map")
    }
  }
}
