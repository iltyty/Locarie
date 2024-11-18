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
  
  private let router = Router.shared

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var favoritePostsVM = FavoritePostViewModel()
  @StateObject private var favoriteBusinessVM = FavoriteBusinessViewModel()

  @State private var isPresentingCover = false
  @State private var currentTab: Tab = .followed

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
      case .saved: savedPosts
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
            BusinessAvatarRow(
              user: user,
              isPresentingCover: $isPresentingCover
            )
          }
          .padding(.bottom, i != users.count - 1 ? 16 : 48)
          .buttonStyle(.plain)
          .tint(.primary)

          if i != users.count - 1 {
            LocarieDivider().padding([.bottom, .horizontal], 16)
          }
        }
      }
    }
  }

  @ViewBuilder
  var savedPosts: some View {
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
              bottomPadding: i == posts.count - 1 ? .small : .zero,
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
