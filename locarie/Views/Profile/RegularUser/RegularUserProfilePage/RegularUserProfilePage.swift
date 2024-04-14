//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct RegularUserProfilePage: View {
  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  @StateObject var favoritePostsVM = FavoritePostViewModel()
  @StateObject var favoriteBusinessVM = FavoriteBusinessViewModel()

  @State var screenHeight: CGFloat = 0
  @State var currentTab: Tab = .followed

  @State var isPresentingCover = false

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Color.black.opacity(0.05).ignoresSafeArea(edges: .all)
        VStack {
          content
          BottomTabView()
        }
      }
      .onAppear {
        let userId = cacheVM.getUserId()
        screenHeight = proxy.size.height
        favoritePostsVM.list(userId: userId)
        favoriteBusinessVM.list(userId: userId)
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }

  var content: some View {
    VStack {
      settingsButton
      Spacer()
      avatarRow
      Spacer()
      BottomSheet(detents: [.medium]) {
        sheetContent
      }
    }
  }
}

extension RegularUserProfilePage {
  var settingsButton: some View {
    HStack {
      Spacer()
      NavigationLink(value: Router.Destination.settings) {
        Image(systemName: "gearshape")
          .font(.system(size: Constants.settingsButtonSize))
          .frame(width: Constants.settingsButtonBgSize, height: Constants.settingsButtonBgSize)
          .overlay {
            Circle()
              .fill(.background)
              .shadow(radius: Constants.settingsButtonShadowRadius)
          }
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal)
  }

  var avatarRow: some View {
    HStack {
      avatar
      username
      Spacer()
      ProfileEditButton()
    }
    .padding(.horizontal)
    .padding(.top, screenHeight * Constants.avatarRowTopPaddingFraction)
  }

  var avatar: some View {
    AvatarView(
      imageUrl: cacheVM.getAvatarUrl(),
      size: Constants.avatarSize
    )
  }

  var username: some View {
    Text(cacheVM.getUsername())
      .font(.title3)
      .fontWeight(.semibold)
  }
}

extension RegularUserProfilePage {
  var sheetContent: some View {
    VStack(spacing: Constants.vSpacing) {
      tabs
      tabContent
    }
  }

  var tabs: some View {
    HStack(spacing: Constants.tabHPadding) {
      Spacer()
      followedTab
      Spacer()
      likedTab
      Spacer()
    }
  }

  var followedTab: some View {
    Label {
      Text("Followed")
    } icon: {
      Image(systemName: "bookmark")
    }
    .fontWeight(isFollowedTabSelected ? .semibold : .regular)
    .padding(.horizontal, Constants.tabTextHPadding)
    .frame(width: Constants.tabWidth, height: Constants.tabHeight)
    .overlay(
      Capsule()
        .strokeBorder(isFollowedTabSelected ? .black : Constants.tabStrokeColor)
    )
    .onTapGesture {
      currentTab = .followed
    }
  }

  var isFollowedTabSelected: Bool {
    currentTab == .followed
  }

  var likedTab: some View {
    Label {
      Text("Likes")
    } icon: {
      Image(systemName: "heart")
    }
    .fontWeight(!isFollowedTabSelected ? .semibold : .regular)
    .padding(.horizontal, Constants.tabTextHPadding)
    .frame(width: Constants.tabWidth, height: Constants.tabHeight)
    .background(
      Capsule()
        .strokeBorder(!isFollowedTabSelected ? .primary : Constants.tabStrokeColor)
    )
    .onTapGesture {
      currentTab = .saved
    }
  }

  @ViewBuilder
  var tabContent: some View {
    switch currentTab {
    case .followed: followedBusinesses
    case .saved: savedPosts
    }
  }

  @ViewBuilder
  var followedBusinesses: some View {
    if case .loading = favoriteBusinessVM.state {
      skeleton
    } else if favoriteBusinessVM.users.isEmpty {
      emptyFollowedBusinesses
    } else {
      ScrollView {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
          ForEach(favoriteBusinessVM.users) { user in
            BusinessFollowedAvatarRow(
              user: user,
              isPresentingCover: $isPresentingCover
            )
          }
        }
      }
    }
  }

  @ViewBuilder
  var savedPosts: some View {
    if case .loading = favoritePostsVM.state {
      skeleton
    } else if favoritePostsVM.posts.isEmpty {
      emptySavedPosts
    } else {
      ScrollView {
        VStack(spacing: Constants.vSpacing) {
          ForEach(favoritePostsVM.posts) { post in
            PostCardView(post)
          }
        }
      }
    }
  }

  var emptyFollowedBusinesses: some View {
    VStack {
      Text("No followed business.")
        .foregroundStyle(.secondary)
        .padding(.top, Constants.emptyTabContentTopPadding)
      Spacer()
    }
  }

  var emptySavedPosts: some View {
    VStack {
      Text("No liked post.")
        .foregroundStyle(.secondary)
        .padding(.top, Constants.emptyTabContentTopPadding)
      Spacer()
    }
  }
}

enum Tab {
  case followed, saved
}

private enum Constants {
  static let vSpacing: CGFloat = 25
  static let avatarSize: CGFloat = 72
  static let avatarRowTopPaddingFraction: CGFloat = 0.1

  static let settingsButtonSize: CGFloat = 18
  static let settingsButtonBgSize: CGFloat = 40
  static let settingsButtonShadowRadius: CGFloat = 2

  static let tabWidth: CGFloat = 140
  static let tabHeight: CGFloat = 40
  static let tabHPadding: CGFloat = 10
  static let tabTextHPadding: CGFloat = 10
  static let tabStrokeColor: Color = .init(hex: 0xF0F0F0)

  static let editButtonHeight: CGFloat = 40
  static let editButtonShadowRadius: CGFloat = 2

  static let emptyTabContentTopPadding: CGFloat = 50
}

#Preview {
  RegularUserProfilePage()
    .environmentObject(Router.shared)
}
