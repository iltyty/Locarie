//
//  BusinessHomePage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct BusinessHomePage: View {
  let uid: Int64
  let locationManager = LocationManager()

  @State private var viewport: Viewport = .camera(
    center: .london,
    zoom: Constants.mapZoom
  )

  @State private var post = PostDto()

  @State private var showingDetailedProfile = false
  @State private var showingPostCover = false
  @State private var showingBusinessProfileCover = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var listNearbyPostsVM = PostListNearbyViewModel()
  @StateObject private var listUserPostsVM = ListUserPostsViewModel()
  @StateObject private var favoritePostVM = FavoritePostViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    GeometryReader { _ in
      ZStack(alignment: .top) {
        mapView
        content
        if showingPostCover {
          postCover
        }
        if showingBusinessProfileCover {
          businessProfileCover
        }
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      profileVM.getProfile(userId: uid)
      listUserPostsVM.getUserPosts(id: uid)
    }
  }

  private var user: UserDto {
    profileVM.dto
  }
}

private extension BusinessHomePage {
  var content: some View {
    VStack(spacing: 0) {
      topContent
      Spacer()
      bottomContent
      bottomBar
    }
  }

  var mapView: some View {
    Map(viewport: $viewport) {
      Puck2D()

      ForEvery(listNearbyPostsVM.posts) { post in
        MapViewAnnotation(coordinate: post.businessLocationCoordinate) {
          BusinessMapAvatar(url: profileVM.dto.avatarUrl)
            .onTapGesture {
              viewport = .camera(
                center: post.businessLocationCoordinate,
                zoom: Constants.mapZoom
              )
            }
        }
      }
    }
    .ignoresSafeArea(edges: .all)
  }

  var topContent: some View {
    HStack {
      backButton
      Spacer()
      shareButton
      moreButton
    }
    .padding(.horizontal)
    .padding(.bottom, Constants.topButtonsBottomPadding)
  }

  var bottomContent: some View {
    BottomSheet(detents: [.medium, .large]) {
      VStack(alignment: .leading) {
        if case .loading = profileVM.state {
          skeleton
        } else {
          BusinessHomeAvatarRow(
            user: user,
            hasUpdates: updatedIn24Hours,
            isPresentingDetail: $showingDetailedProfile
          )
          ProfileCategories(user)
        }
        ScrollView {
          VStack(alignment: .leading, spacing: Constants.vSpacing) {
            if case .loading = profileVM.state {
              EmptyView()
            } else {
              ProfileBio(user)
              if showingDetailedProfile {
                ProfileDetail(user)
              }
            }
            if case .loading = listUserPostsVM.state {
              PostCardView.skeleton
            } else {
              ProfilePostsCount(listUserPostsVM.posts)
              ForEach(listUserPostsVM.posts) { p in
                PostCardView(p).onTapGesture {
                  post = p
                  showingPostCover = true
                }
              }
            }
          }
        }
        .scrollIndicators(.hidden)
      }
    }
  }

  var updatedIn24Hours: Bool {
    !listUserPostsVM.posts.isEmpty &&
      Date().timeIntervalSince(listUserPostsVM.posts[0].time) < 86400
  }

  var bottomBar: some View {
    BusinessBottomBar(businessId: uid, location: user.location).background(.background)
  }
}

private extension BusinessHomePage {
  var backButton: some View {
    CircleButton(systemName: "chevron.backward")
      .onTapGesture {
        dismiss()
      }
  }

  var shareButton: some View {
    CircleButton(name: "ShareIcon")
  }

  var moreButton: some View {
    CircleButton(systemName: "ellipsis")
  }
}

private extension BusinessHomePage {
  var postCover: some View {
    PostCover(post: post, isPresenting: $showingPostCover)
  }

  var businessProfileCover: some View {
    BusinessProfileCover(user: user, isPresenting: $showingBusinessProfileCover)
  }

  func toggleShowingBusinessProfileCover() {
    withAnimation(.spring) {
      showingBusinessProfileCover.toggle()
    }
  }

  func toggleShowingPostContentCover() {
    withAnimation(.spring) {
      showingPostCover.toggle()
    }
  }
}

private extension BusinessHomePage {
  var skeleton: some View {
    VStack(alignment: .leading) {
      HStack {
        SkeletonView(74, 74, true)
        VStack(alignment: .leading) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
      }
      HStack {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
      }
      SkeletonView(48, 10)
    }
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 72
  static let vSpacing: CGFloat = 15
  static let mapZoom: CGFloat = 12
  static let topButtonsBottomPadding: CGFloat = 3
}

#Preview {
  BusinessHomePage(uid: 1)
}
