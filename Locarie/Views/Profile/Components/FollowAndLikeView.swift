//
//  FollowAndLikeView.swift
//  locarie
//
//  Created by qiuty on 15/04/2024.
//

import CoreLocation
import SwiftUI

struct FollowAndLikeView: View {
  @Binding var post: PostDto
  @Binding var user: UserDto
  @Binding var isPostCoverPresented: Bool
  @Binding var isProfileCoverPresented: Bool

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  // TODO: fix pagination bug
  @StateObject private var favoritePostsVM = FavoritePostViewModel(size: 1000)
  @StateObject private var favoriteBusinessVM = FavoriteBusinessViewModel(userSize: 1000)

  @State private var prePostIndex = 0
  @State private var preUserIndex = 0
  @State private var shouldFetchPost = false
  @State private var shouldFetchUser = false
  @State private var isPresentingCover = false
  @State private var currentTab: Tab = .followed
  
  private let router = Router.shared
  private let postScrollViewCoordinateSpace = "postScrollView"
  private let userScrollViewCoordinateSpace = "userScrollView"

  var body: some View {
    VStack(spacing: 24) {
      HStack(spacing: 16) {
        followedTab
        likedTab
      }
      .padding(.horizontal, 16)
      tabContent
    }
    .onAppear {
      let userId = cacheVM.getUserId()
      favoritePostsVM.list(userId: userId)
      favoriteBusinessVM.list(userId: userId)
    }
    .onChange(of: shouldFetchPost) { _ in
      favoritePostsVM.list(userId: cacheVM.getUserId())
    }
    .onChange(of: shouldFetchUser) { _ in
      favoriteBusinessVM.list(userId: cacheVM.getUserId())
    }
  }
}

private extension FollowAndLikeView {
  var followedTab: some View {
    HStack(spacing: 10) {
      Image("Bookmark")
        .resizable()
        .scaledToFit()
        .frame(size: 16)
      Text("Following")
    }
    .frame(height: Constants.tabHeight)
    .frame(maxWidth: .infinity)
    .background(
      Capsule()
        .stroke(isFollowedTabSelected ? .black : LocarieColor.greyMedium, style: .init(lineWidth: 1.5))
        .padding(0.75)
    )
    .onTapGesture {
      currentTab = .followed
    }
  }

  var isFollowedTabSelected: Bool {
    currentTab == .followed
  }

  var likedTab: some View {
    HStack(spacing: 10) {
      Image("Heart")
        .resizable()
        .scaledToFit()
        .frame(size: 16)
      Text("Likes")
    }
    .frame(height: Constants.tabHeight)
    .frame(maxWidth: .infinity)
    .background(
      Capsule()
        .stroke(!isFollowedTabSelected ? .black : LocarieColor.greyMedium, style: .init(lineWidth: 1.5))
        .padding(0.75)
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
      case .saved: likedPosts
      }
    }
    .padding(.bottom, 16)
  }

  @ViewBuilder
  var followedBusinesses: some View {
    if case .loading = favoriteBusinessVM.state {
      followingSkeleton.frame(maxHeight: .infinity, alignment: .top).padding(.horizontal, 16)
    } else if favoriteBusinessVM.users.isEmpty {
      emptyFollowedBusinesses
    } else {
      VStack(alignment: .leading, spacing: 0) {
        // reversed: newest to oldest
        ForEach(favoriteBusinessVM.users.indices.reversed(), id: \.self) { i in
          let users = favoriteBusinessVM.users
          let user = users[i]
          NavigationLink(value: Router.BusinessHomeDestination.businessHome(
            user.id,
            user.location?.latitude ?? CLLocationCoordinate2D.london.latitude,
            user.location?.longitude ?? CLLocationCoordinate2D.london.longitude,
            true
          )) {
            BusinessAvatarRow(user: user, isPresentingCover: $isPresentingCover)
          }
          .padding(.bottom, i != users.count - 1 ? 16 : 48)
          .buttonStyle(.plain)
          .tint(.primary)

          if i != users.count - 1 {
            LocarieDivider().padding([.bottom, .horizontal], 16)
          }
        }
        .background {
          GeometryReader { proxy in
            Color.clear.preference(key: UserViewOffsetKey.self, value: -(proxy.frame(in: .named(userScrollViewCoordinateSpace)).origin.y - 16))
          }
        }
        .onPreferenceChange(UserViewOffsetKey.self) { offset in
          let i = Int(offset) / GlobalConstants.userCardHeight
          if i <= preUserIndex {
            preUserIndex = i
            return
          }
          preUserIndex = i
          let delta = favoriteBusinessVM.users.count - 5
          if delta <= 0 || i == delta || i == favoriteBusinessVM.users.count {
            shouldFetchUser.toggle()
          }
        }
      }
    }
  }

  @ViewBuilder
  var likedPosts: some View {
    if case .loading = favoritePostsVM.state {
      PostCardView.skeleton.frame(maxHeight: .infinity, alignment: .top)
    } else if favoritePostsVM.posts.isEmpty {
      emptySavedPosts
    } else {
      let posts = favoritePostsVM.posts
      ScrollView {
        VStack(spacing: 0) {
          // reversed: newest to oldest
          ForEach(posts.indices.reversed(), id: \.self) { i in
            PostCardView(
              posts[i],
              bottomPadding: i == 0 ? .small : .zero,
              onTapped: {
                router.navigate(to: Router.BusinessHomeDestination.businessHome(
                  posts[i].user.id,
                  user.location?.latitude ?? CLLocationCoordinate2D.london.latitude,
                  user.location?.longitude ?? CLLocationCoordinate2D.london.longitude,
                  true
                ))
              },
              onCoverTapped: {
                post = posts[i]
                user = posts[i].user
                isPostCoverPresented = true
              },
              onThumbnailTapped: {
                post = posts[i]
                user = posts[i].user
                isProfileCoverPresented = true
              }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, i != posts.count - 1 ? 16 : 48)
            
            if i != posts.count - 1 {
              LocarieDivider().padding([.bottom, .horizontal], 16)
            }
          }
          .background {
            GeometryReader { proxy in
              Color.clear.preference(key: PostViewOffsetKey.self, value: -(proxy.frame(in: .named(postScrollViewCoordinateSpace)).origin.y - 16))
            }
          }
          .onPreferenceChange(PostViewOffsetKey.self) { offset in
            let i = Int(offset) / GlobalConstants.postCardHeight
            if i <= prePostIndex {
              prePostIndex = i
              return
            }
            prePostIndex = i
            let delta = favoritePostsVM.posts.count - 5
            if delta <= 0 || i == delta || i == favoritePostsVM.posts.count {
              shouldFetchPost.toggle()
            }
          }
        }
      }
      .scrollIndicators(.hidden)
    }
  }

  var emptyFollowedBusinesses: some View {
    VStack(spacing: 16) {
      Image("Bookmark.Grey")
        .resizable()
        .scaledToFit()
        .frame(size: 40)
      Text("No followed yet")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
      Spacer()
    }
    .padding(.top, 108)
  }

  var emptySavedPosts: some View {
    VStack(spacing: 16) {
      Image("Heart.Grey")
        .resizable()
        .scaledToFit()
        .frame(size: 40)
      Text("No likes yet")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
      Spacer()
    }
    .padding(.top, 108)
  }
}

private extension FollowAndLikeView {
  var followingSkeleton: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 10) {
        RoundedAvatarSkeletonView(size: 72)
        VStack(alignment: .leading, spacing: 10) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      HStack(spacing: 5) {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
      }
    }
  }
}

private extension FollowAndLikeView {
  enum Tab {
    case followed, saved
  }
}

private extension FollowAndLikeView {
  struct PostViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
  }

  struct UserViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
  }
}

private enum Constants {
  static let tabWidth: CGFloat = 170
  static let tabHeight: CGFloat = 40
  static let emptyTabContentTopPadding: CGFloat = 50
}

private struct FollowTestView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 10) {
        RoundedAvatarSkeletonView(size: 72)
        VStack(alignment: .leading, spacing: 10) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      HStack(spacing: 5) {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
      }
    }
  }
}

#Preview {
  FollowTestView()
}
