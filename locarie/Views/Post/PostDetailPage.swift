//
//  PostDetailPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct PostDetailPage: View {
  @Environment(\.dismiss) var dismiss

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var listNearbyPostsVM = PostListNearbyViewModel()
  @StateObject private var listUserPostsVM = ListUserPostsViewModel()
  @StateObject private var favoritePostVM = FavoritePostViewModel()

  @State private var screenSize: CGSize = .zero
  @State private var viewport: Viewport = .camera(
    center: .london,
    zoom: Constants.mapZoom
  )

  @State private var user = UserDto()
  @State private var post = PostDto()

  @State private var showingDetailedProfile = false
  @State private var showingPostCover = false
  @State private var showingBusinessProfileCover = false

  let uid: Int64
  let locationManager = LocationManager()

  var body: some View {
    GeometryReader { proxy in
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
      .onAppear {
        screenSize = proxy.size
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      profileVM.getProfile(userId: uid)
      listUserPostsVM.getUserPosts(id: uid)
    }
    .onReceive(profileVM.$state) { state in
      if case .finished = state {
        user = profileVM.dto
      }
    }
  }
}

private extension PostDetailPage {
  var content: some View {
    VStack {
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
          Image("map").foregroundStyle(Color.locariePrimary)
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
  }

  var bottomContent: some View {
    BottomSheet(detents: [.minimum, .large]) {
      VStack(alignment: .leading) {
        BusinessHomeAvatarRow(
          user: user,
          isPresentingDetail: $showingDetailedProfile
        )
        ScrollView {
          VStack(alignment: .leading, spacing: Constants.vSpacing) {
            ProfileCategories(user)
            ProfileBio(user)
            if showingDetailedProfile {
              ProfileDetail(user)
            }
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
    }
  }

  var bottomBar: some View {
    BusinessBottomBar(businessId: uid)
  }
}

private extension PostDetailPage {
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

private extension PostDetailPage {
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

private enum Constants {
  static let avatarSize: CGFloat = 72
  static let vSpacing: CGFloat = 15
  static let mapZoom: CGFloat = 12
}

#Preview {
  PostDetailPage(uid: 1)
}
