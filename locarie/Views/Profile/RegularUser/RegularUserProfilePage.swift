//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct RegularUserProfilePage: View {
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @StateObject private var favoritePostsVM = FavoritePostViewModel()
  @StateObject private var favoriteBusinessVM = FavoriteBusinessViewModel()

  @State private var screenHeight: CGFloat = 0
  @State private var currentTab: Tab = .followed

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

  private var content: some View {
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

private extension RegularUserProfilePage {
  var settingsButton: some View {
    HStack {
      Spacer()
      NavigationLink(value: Router.Destination.settings) {
        Image(systemName: "gearshape")
          .font(.system(size: Constants.settingsButtonSize))
          .padding(.trailing)
      }
      .buttonStyle(.plain)
    }
  }

  var avatarRow: some View {
    HStack {
      avatar
      username
      Spacer()
      profileEditButton
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
      .font(.headline)
      .fontWeight(.semibold)
  }

  var profileEditButton: some View {
    NavigationLink(value: Router.Destination.userProfileEdit) {
      Text("Edit Profile")
        .padding()
        .background(profileEditButtonBackground)
    }
    .buttonStyle(.plain)
  }

  var profileEditButtonBackground: some View {
    Capsule()
      .fill(.background)
      .frame(height: Constants.editButtonHeight)
      .shadow(radius: Constants.editButtonShadowRadius)
  }
}

private extension RegularUserProfilePage {
  var sheetContent: some View {
    VStack(spacing: Constants.vSpacing) {
      tabs
      tabContent
    }
  }

  var tabs: some View {
    ScrollView(.horizontal) {
      HStack(spacing: Constants.tabHPadding) {
        followedTab
        savedTab
      }
    }
  }

  var followedTab: some View {
    Label("Followed", systemImage: "bookmark")
      .padding(.horizontal, Constants.tabTextHPadding)
      .frame(height: Constants.tabHeight)
      .background(
        Capsule()
          .stroke(currentTab == .followed ? .primary : Constants.tabStrokeColor)
      )
      .onTapGesture {
        currentTab = .followed
      }
  }

  var savedTab: some View {
    Label("Saved", systemImage: "star")
      .padding(.horizontal, Constants.tabTextHPadding)
      .frame(height: Constants.tabHeight)
      .background(
        Capsule()
          .stroke(currentTab == .saved ? .primary : Constants.tabStrokeColor)
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
    if favoriteBusinessVM.users.isEmpty {
      emptyFollowedBusinesses
    } else {
      ScrollView {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
          ForEach(favoriteBusinessVM.users) { user in
            BusinessRowView(user)
          }
        }
      }
    }
  }

  @ViewBuilder
  var savedPosts: some View {
    if favoritePostsVM.posts.isEmpty {
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
      Text("No saved post.")
        .foregroundStyle(.secondary)
        .padding(.top, Constants.emptyTabContentTopPadding)
      Spacer()
    }
  }
}

private enum Tab {
  case followed, saved
}

private enum Constants {
  static let vSpacing: CGFloat = 25
  static let avatarSize: CGFloat = 72
  static let avatarRowTopPaddingFraction: CGFloat = 0.1

  static let settingsButtonSize: CGFloat = 25

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
