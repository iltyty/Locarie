//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct RegularUserProfilePage: View {
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

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
        screenHeight = proxy.size.height
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
    VStack {
      tabs
      ScrollView {
        VStack {
          tabContent
        }
      }
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
    case .followed: followedUsers
    case .saved: savedPosts
    }
  }

  var followedUsers: some View {
    emptyFollowedPosts
  }

  var emptyFollowedPosts: some View {
    VStack {
      Spacer()
      Text("No followed business.").foregroundStyle(.secondary)
      Spacer()
    }
  }

  var savedPosts: some View {
    emptySavedPosts
  }

  var emptySavedPosts: some View {
    VStack {
      Spacer()
      Text("No saved post.").foregroundStyle(.secondary)
      Spacer()
    }
  }
}

private enum Tab {
  case followed, saved
}

private enum Constants {
  static let avatarSize: CGFloat = 72
  static let avatarRowTopPaddingFraction: CGFloat = 0.1

  static let settingsButtonSize: CGFloat = 25

  static let tabHeight: CGFloat = 40
  static let tabHPadding: CGFloat = 10
  static let tabTextHPadding: CGFloat = 10
  static let tabStrokeColor: Color = .init(hex: 0xF0F0F0)

  static let editButtonHeight: CGFloat = 40
  static let editButtonShadowRadius: CGFloat = 2
}

#Preview {
  RegularUserProfilePage()
    .environmentObject(Router.shared)
}
