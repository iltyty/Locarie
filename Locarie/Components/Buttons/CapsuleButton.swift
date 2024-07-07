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

  @ViewBuilder
  private var background: some View {
    if #available(iOS 17.0, *) {
      Capsule()
        .fill(.background)
        .stroke(LocarieColor.lightGray)
    } else {
      Capsule()
        .stroke(LocarieColor.lightGray)
        .background(Capsule().fill(.background))
    }
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
