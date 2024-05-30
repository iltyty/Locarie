//
//  FollowAndLikeView.swift
//  locarie
//
//  Created by qiuty on 15/04/2024.
//

import SwiftUI

struct FollowAndLikeView: View {
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var favoritePostsVM = FavoritePostViewModel()
  @StateObject private var favoriteBusinessVM = FavoriteBusinessViewModel()

  @State private var isPresentingCover = false
  @State private var currentTab: Tab = .followed

  var body: some View {
    VStack(spacing: Constants.vSpacing) {
      tabs
      tabContent
    }
    .onAppear {
      let userId = cacheVM.getUserId()
      favoritePostsVM.list(userId: userId)
      favoriteBusinessVM.list(userId: userId)
    }
  }
}

private extension FollowAndLikeView {
  var tabs: some View {
    HStack {
      Spacer()
      followedTab
      Spacer()
      likedTab
      Spacer()
    }
  }

  var followedTab: some View {
    Label {
      Text("Following")
    } icon: {
      Image(systemName: "bookmark")
    }
    .fontWeight(isFollowedTabSelected ? .semibold : .regular)
    .padding(.horizontal)
    .frame(width: Constants.tabWidth, height: Constants.tabHeight)
    .overlay(
      Capsule()
        .strokeBorder(isFollowedTabSelected ? .black : LocarieColor.greyMedium)
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
    .frame(width: Constants.tabWidth, height: Constants.tabHeight)
    .background(
      Capsule()
        .strokeBorder(!isFollowedTabSelected ? .primary : LocarieColor.greyMedium)
    )
    .onTapGesture {
      currentTab = .saved
    }
  }

  @ViewBuilder
  var tabContent: some View {
    Group {
      switch currentTab {
      case .followed: followedBusinesses
      case .saved: savedPosts
      }
    }
    .padding(.horizontal)
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

private extension FollowAndLikeView {
  var skeleton: some View {
    VStack {
      HStack {
        RoundedAvatarSkeletonView(size: 114)
        VStack(alignment: .leading) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
          HStack {
            SkeletonView(68, 11)
            SkeletonView(68, 11)
          }
        }
        Spacer()
      }
      Spacer()
    }
  }
}

private extension FollowAndLikeView {
  enum Tab {
    case followed, saved
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 25

  static let tabWidth: CGFloat = 140
  static let tabHeight: CGFloat = 40
  static let emptyTabContentTopPadding: CGFloat = 50
}

#Preview {
  FollowAndLikeView()
}
