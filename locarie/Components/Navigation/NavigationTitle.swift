//
//  NavigationTitle.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import SwiftUI

struct NavigationTitle<L: View, R: View>: View {
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
        titleText(title)
      }
      if showDivider {
        Divider()
      }
    }
    .padding(.bottom)
    .padding(.bottom, padding ? Constants.bottomPadding : 0)
  }
}

private extension NavigationTitle {
  func titleButtons(left: some View, right: some View) -> some View {
    HStack {
      left
        .onTapGesture {
          dismiss()
        }
      Spacer()
      right
    }
    .padding(.horizontal)
  }

  func titleText(_ text: String) -> some View {
    Text(text)
      .font(.headline)
      .fontWeight(.bold)
  }
}

private func defaultTitleLeft() -> some View {
  Image(systemName: "chevron.left")
    .resizable()
    .scaledToFit()
    .fontWeight(.semibold)
    .frame(width: Constants.leftIconSize, height: Constants.leftIconSize)
}

private func defaultTitleRight() -> EmptyView {
  EmptyView()
}

private enum Constants {
  static let leftIconSize: CGFloat = 18
  static let bottomPadding: CGFloat = 80
}

#Preview {
  NavigationTitle("Navigation Title", divider: true)
}
