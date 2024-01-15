//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct RegularUserProfilePage: View {
  @ObservedObject private var cacheViewModel = LocalCacheViewModel.shared

  @State private var topSafeAreaHeight = 0.0
  @State private var currentTab: Tab = .followed

  @Environment(\.colorScheme) private var colorScheme: ColorScheme

  var body: some View {
    GeometryReader { proxy in
      VStack {
        content
        BottomTabView()
      }
      .ignoresSafeArea(edges: .top)
      .onAppear {
        topSafeAreaHeight = proxy.safeAreaInsets.top
      }
    }
  }

  var content: some View {
    ScrollView {
      topContent
      bottomContent
    }
  }
}

private extension RegularUserProfilePage {
  var topContent: some View {
    VStack {
      settingsButton
      avatar
      username
      profileEditButton
    }
    .padding(.top, topSafeAreaHeight)
    .padding(.bottom)
    .background(.thinMaterial)
  }

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

  var avatar: some View {
    cacheViewModel.getAvatarUrl().isEmpty
      ? AvatarView(
        size: Constants.avatarSize
      )
      : AvatarView(
        imageUrl: cacheViewModel.getAvatarUrl(),
        size: Constants.avatarSize
      )
  }

  var username: some View {
    Text(cacheViewModel.getUsername())
      .frame(minHeight: Constants.usernameMinHeight)
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
      .fill(colorScheme == .light ? .white : .gray)
      .frame(height: Constants.editButtonHeight)
      .shadow(radius: Constants.editButtonShadowRadius)
  }
}

private extension RegularUserProfilePage {
  var bottomContent: some View {
    VStack(spacing: Constants.bottomContentVSpacing) {
      tabs
      mapIcon
      switch currentTab {
      case .followed: followedPosts
      case .saved: savedPosts
      }
    }
    .padding(.horizontal)
    .background(bottomContentBackground)
  }

  var tabs: some View {
    HStack {
      followedTab
      savedTab
    }
    .padding(.top)
  }

  var followedTab: some View {
    HStack {
      Spacer()
      Label("Followed", systemImage: "bookmark")
        .fontWeight(currentTab == .followed ? .bold : .regular)
        .onTapGesture {
          currentTab = .followed
        }
      Spacer()
    }
  }

  var savedTab: some View {
    HStack {
      Spacer()
      Label("Saved", systemImage: "star")
        .fontWeight(currentTab == .saved ? .bold : .regular)
        .onTapGesture {
          currentTab = .saved
        }
      Spacer()
    }
  }

  var mapIcon: some View {
    VStack(spacing: Constants.bottomContentVSpacing) {
      Divider()
      Image(systemName: "map")
      Divider()
    }
  }

  var bottomContentBackground: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: Constants.bottomContentackgroundRadius,
      topTrailingRadius: Constants.bottomContentackgroundRadius
    )
    .fill(.background)
  }

  var followedPosts: some View {
    // - TODO: posts content
    emptyFollowedPosts
  }

  var emptyFollowedPosts: some View {
    VStack {
      Spacer()
      Text("No followed moments.").foregroundStyle(.secondary)
      Spacer()
    }
  }

  var savedPosts: some View {
    // - TODO: posts content
    emptySavedPosts
  }

  var emptySavedPosts: some View {
    VStack {
      Spacer()
      Text("No saved moments.").foregroundStyle(.secondary)
      Spacer()
    }
  }
}

private extension RegularUserProfilePage {
  enum Tab {
    case followed, saved
  }
}

private enum Constants {
  static let settingsButtonSize = 25.0
  static let avatarSize = 80.0
  static let usernameMinHeight = 24.0
  static let editButtonHeight = 40.0
  static let editButtonShadowRadius = 2.0
  static let bottomContentVSpacing = 20.0
  static let bottomContentShadowRadius = 4.0
  static let bottomContentackgroundRadius = 10.0
}

#Preview {
  RegularUserProfilePage()
    .environmentObject(Router.shared)
}
