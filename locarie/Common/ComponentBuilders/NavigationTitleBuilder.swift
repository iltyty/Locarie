//
//  NavigationTitleBuilder.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Foundation
import SwiftUI

func navigationTitleBuilder(
  title: String,
  left: some View = defaultNavigationLeftView(),
  right: some View = EmptyView()
) -> some View {
  ZStack(alignment: .top) {
    titleButtons(left: left, right: right)
    titleText(title)
  }
}

private func defaultNavigationLeftView() -> some View {
  Image(systemName: "chevron.left")
    .padding(.leading)
}

private func titleButtons(left: some View, right: some View) -> some View {
  HStack {
    left
    Spacer()
    right
  }
}

private func titleText(_ text: String) -> some View {
  Text(text)
    .font(.headline)
    .fontWeight(.bold)
}
