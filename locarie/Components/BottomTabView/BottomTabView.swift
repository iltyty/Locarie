//
//  BottomTabView.swift
//  locarie
//
//  Created by qiuty on 2023/11/5.
//

import SwiftUI

struct BottomTabView: View {
  @ObservedObject var viewRouter = BottomTabViewRouter.shared
  @ObservedObject var cacheViewModel = LocalCacheViewModel.shared

  private let iconNames = ["location", "plus.app", "person"]

  var body: some View {
    HStack {
      Spacer()
      homePage
      Spacer()
      Spacer()
      if cacheViewModel.isBusinessUser() {
        newPostPage
        Spacer()
        Spacer()
      }
      profilePage
      Spacer()
    }
    .imageScale(.large)
    .frame(height: Constants.height)
    .padding(.horizontal, Constants.horizontalPadding)
    .background(.regularMaterial)
  }
}

private extension BottomTabView {
  var homePage: some View {
    BottomTabViewItem(
      page: .home,
      iconName: "location"
    )
  }

  var newPostPage: some View {
    BottomTabViewItem(
      page: .new,
      iconName: "plus.app"
    )
  }

  var profilePage: some View {
    BottomTabViewItem(
      page: .profile,
      iconName: "person"
    )
  }
}

private enum Constants {
  static let height: CGFloat = 60
  static let iconSize: CGFloat = 25
  static let horizontalPadding: CGFloat = 40
}

#Preview {
  ZStack {
    Color.blue
    BottomTabView()
  }
}
