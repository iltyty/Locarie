//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct RegularUserProfilePage: View {
  @EnvironmentObject var cacheViewModel: LocalCacheViewModel
  @EnvironmentObject var postViewModel: PostViewModel
  @Environment(\.colorScheme) var colorScheme: ColorScheme

  init() {}

  var body: some View {
    if cacheViewModel.isLoggedIn() {
      content
    } else {
      loginOrRegister
    }
  }

  var content: some View {
    NavigationStack {
      GeometryReader { proxy in
        VStack(spacing: 0) {
          ScrollView {
            topView.padding(.bottom)
            bottomView(screenWidth: proxy.size.width)
          }
          .background(.background)
          BottomTabView()
        }
      }
    }
  }

  var loginOrRegister: some View {
    VStack {
      LoginOrRegisterPage()
      BottomTabView()
    }
  }
}

extension RegularUserProfilePage {
  var topView: some View {
    VStack {
      topViewSettings
      topViewAvatar
      topViewUsername
      topViewBtnEdit
    }
  }

  var topViewSettings: some View {
    HStack {
      Spacer()
      Image(systemName: "gearshape")
        .resizable()
        .frame(
          width: Constants.btnSettingsSize,
          height: Constants.btnSettingsSize
        )
        .padding(.trailing)
    }
  }

  var topViewAvatar: some View {
    cacheViewModel.getAvatarUrl().isEmpty
      ? AvatarView(
        systemName: "person.crop.circle",
        size: Constants.avatarSize
      )
      : AvatarView(
        imageUrl: cacheViewModel.getAvatarUrl(),
        size: Constants.avatarSize
      )
  }

  var topViewUsername: some View {
    Text(cacheViewModel.getUsername())
  }

  var topViewBtnEdit: some View {
    Text("Edit Profile")
      .foregroundStyle(.primary)
      .padding()
      .background(
        Capsule()
          .fill(colorScheme == .light ? .white : .gray)
          .frame(height: Constants.btnEditHeight)
          .shadow(radius: Constants.btnEditShadowRadius)
      )
  }
}

extension RegularUserProfilePage {
  func bottomView(screenWidth _: CGFloat) -> some View {
    VStack(spacing: Constants.bottomViewVSpacing) {
      HStack {
        Spacer()
        Label("Followed", systemImage: "bookmark")
        Spacer()
        Label("Saved", systemImage: "star")
        Spacer()
      }
      Divider()
        .padding(.horizontal)
      Image(systemName: "map")
      Divider()
        .padding(.horizontal)
      // FIXME: Post -> PostDto
//      ForEach(postViewModel.favoritePosts) { post in
//        PostCardView(post: post, coverWidth: screenWidth * 0.8)
//      }
    }
    .padding(.top)
    .background(
      UnevenRoundedRectangle(
        topLeadingRadius: Constants.bottomViewBackgroundRadius,
        topTrailingRadius: Constants.bottomViewBackgroundRadius
      )
      .fill(.background)
      .shadow(radius: Constants.bottomViewShadowRadius)
    )
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 80
  static let btnSettingsSize: CGFloat = 25
  static let btnEditHeight: CGFloat = 40
  static let btnEditShadowRadius: CGFloat = 2
  static let bottomViewVSpacing: CGFloat = 20
  static let bottomViewShadowRadius: CGFloat = 4
  static let bottomViewBackgroundRadius: CGFloat = 10
}

#Preview {
  RegularUserProfilePage()
    .environmentObject(BottomTabViewRouter())
    .environmentObject(PostViewModel())
    .environmentObject(LocalCacheViewModel())
}
