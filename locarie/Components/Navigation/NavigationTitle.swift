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

  init(
    left: L = defaultTitleLeft(),
    right: R = defaultTitleRight(),
    _ title: String
  ) {
    self.left = left
    self.right = right
    self.title = title
  }

  var body: some View {
    ZStack(alignment: .top) {
      titleButtons(left: left, right: right)
      titleText(title)
    }
  }
}

private extension NavigationTitle {
  static func defaultTitleLeft() -> Image {
    Image(systemName: "chevron.left")
  }

  static func defaultTitleRight() -> EmptyView {
    EmptyView()
  }

  func titleButtons(left: some View, right: some View) -> some View {
    HStack {
      left
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

#Preview {
  NavigationTitle("Navigation Title")
}
