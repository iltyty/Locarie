//
//  NavigationBar.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct NavigationBar<L: View, R: View>: View {
  let left: L
  let right: R
  let title: String
  let showDivider: Bool
  let padding: Bool

  @Environment(\.dismiss) var dismiss

  init(
    _ title: String = "",
    left: L = defaultTitleLeft(),
    right: R = defaultTitleRight(),
    divider showDivider: Bool = false,
    padding: Bool = false
  ) {
    self.left = left
    self.right = right
    self.title = title
    self.showDivider = showDivider
    self.padding = padding
  }

  var body: some View {
    VStack {
      ZStack(alignment: .top) {
        titleButtons(left: left, right: right)
        Text(title).fontWeight(.bold)
      }
      if showDivider {
        Divider()
      }
    }
    .padding(.top, Constants.topPadding)
    .padding(.bottom, padding ? Constants.bottomPadding : 0)
  }
}

private extension NavigationBar {
  func titleButtons(left: L, right: R) -> some View {
    HStack {
      left
        .contentShape(Rectangle())
        .onTapGesture { dismiss() }
      Spacer()
      right
    }
    .padding(.horizontal, 18)
  }
}

private func defaultTitleLeft() -> AnyView {
  AnyView(Image(systemName: "chevron.left")
    .resizable()
    .scaledToFit()
    .frame(width: Constants.leftIconSize, height: Constants.leftIconSize))
}

private func defaultTitleRight() -> EmptyView {
  EmptyView()
}

private enum Constants {
  static let leftIconSize: CGFloat = 18
  static let topPadding: CGFloat = 3
  static let bottomPadding: CGFloat = 100
}
