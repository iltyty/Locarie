//
//  BottomTabView.swift
//  locarie
//
//  Created by qiuty on 2023/11/5.
//

import SwiftUI

struct BottomTabView: View {
  @ObservedObject var cacheVM = LocalCacheViewModel.shared
  @ObservedObject var viewRouter = BottomTabViewRouter.shared

  var body: some View {
    HStack {
      Spacer()
      homePage
      Spacer()
      if cacheVM.isBusinessUser() {
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
    Rectangle()
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
    ).onTapGesture {
      setPage(.home)
    }
  }

  var newPostPage: some View {
    NavigationLink {
      NewPostPage()
    } label: {
      BottomTabViewItem(
        page: .none,
        iconName: "PlusIcon"
      )
    }
  }

  @ViewBuilder
  var profilePage: some View {
    Group {
      BottomTabViewItem(
        page: .profile,
        iconName: "MyIcon",
        selectedIconName: "SelectedMyIcon"
      )
    }.onTapGesture {
      setPage(.profile)
    }
  }

  func setPage(_ page: Page) {
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    viewRouter.currentPage = page
  }
}

private enum Constants {
  static let height: CGFloat = 78
  static let offset: CGFloat = -10
  static let cornerRadius: CGFloat = 20
  static let shadowRadius: CGFloat = 1
}

#Preview {
  ZStack(alignment: .bottom) {
    Color.pink
    BottomTabView()
  }
  .ignoresSafeArea(edges: .bottom)
}
