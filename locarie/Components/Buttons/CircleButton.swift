//
//  CircleButton.swift
//  locarie
//
//  Created by qiuty on 04/02/2024.
//

import SwiftUI

struct CircleButton: View {
  let systemName: String

  var body: some View {
    Image(systemName: systemName)
      .font(.system(size: Constants.iconSize))
      .background(iconBackground)
  }

  private var iconBackground: some View {
    Circle()
      .fill(.background)
      .frame(width: Constants.size, height: Constants.size)
      .shadow(radius: Constants.shadow)
  }
}

private enum Constants {
  static let size = 48.0
  static let iconSize = 24.0
  static let shadow = 2.0
}

#Preview {
  ZStack {
    Color.red
    CircleButton(systemName: "magnifyingglass")
  }
}
