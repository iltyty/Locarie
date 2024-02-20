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

  var body: some View {
    HStack {
      Spacer()
      homePage
      Spacer()
      if cacheViewModel.isBusinessUser() {
        newPostPage
        Spacer()
      }
      profilePage
      Spacer()
    }
    .frame(height: Constants.height)
    .offset(y: Constants.offset)
    .background(background)
    .ignoresSafeArea(edges: .bottom)
  }

  private var background: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: Constants.cornerRadius,
      topTrailingRadius: Constants.cornerRadius
    )
    .fill(.background)
    .shadow(radius: Constants.shadowRadius)
  }
}

private extension BottomTabView {
  var homePage: some View {
    BottomTabViewItem(
      page: .home,
      iconName: "HomeIcon",
      selectedIconName: "SelectedHomeIcon"
    )
  }

  var newPostPage: some View {
    BottomTabViewItem(
      page: .new,
      iconName: "PlusIcon"
    )
  }

  var profilePage: some View {
    BottomTabViewItem(
      page: .profile,
      iconName: "ProfileIcon"
    )
  }
}

private enum Constants {
  static let height: CGFloat = 90
  static let offset: CGFloat = -10
  static let cornerRadius: CGFloat = 20
  static let shadowRadius: CGFloat = 2
}

#Preview {
  ZStack(alignment: .bottom) {
    Color.white
    BottomTabView()
  }
  .ignoresSafeArea(edges: .bottom)
}
