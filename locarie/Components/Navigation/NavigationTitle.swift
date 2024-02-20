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

  @Environment(\.dismiss) var dismiss

  init(
    _ title: String = "",
    left: L = defaultTitleLeft(),
    right: R = defaultTitleRight(),
    divider showDivider: Bool = false
  ) {
    self.left = left
    self.right = right
    self.title = title
    self.showDivider = showDivider
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
}

#Preview {
  NavigationTitle("Navigation Title", divider: true)
}
