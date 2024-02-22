//
//  CircleButton.swift
//  locarie
//
//  Created by qiuty on 04/02/2024.
//

import SwiftUI

struct CircleButton: View {
  let name: String
  let systemName: String
  let size: CGFloat

  init(name: String, size: CGFloat = Constants.size) {
    self.name = name
    systemName = ""
    self.size = size
  }

  init(systemName: String, size: CGFloat = Constants.size) {
    name = ""
    self.systemName = systemName
    self.size = size
  }

  var body: some View {
    iconBackground.overlay(icon)
  }

  @ViewBuilder
  private var icon: some View {
    Group {
      if name.isEmpty {
        Image(systemName: systemName)
          .resizable()
          .scaledToFit()
      } else {
        Image(name)
          .resizable()
          .scaledToFit()
      }
    }
    .frame(width: Constants.iconSize, height: Constants.iconSize)
  }

  private var iconBackground: some View {
    Circle()
      .fill(.background)
      .frame(width: size, height: size)
      .shadow(radius: Constants.shadow)
  }
}

private enum Constants {
  static let size: CGFloat = 40
  static let iconSize: CGFloat = 18
  static let shadow: CGFloat = 2
}

#Preview {
  ZStack {
    Color.red
    HStack {
      CircleButton(name: "ShareIcon")
      CircleButton(systemName: "magnifyingglass")
    }
  }
}
