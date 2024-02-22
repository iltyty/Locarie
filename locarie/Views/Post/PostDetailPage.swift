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

  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var listNearbyPostsVM = PostListNearbyViewModel()
  @StateObject private var listUserPostsVM = ListUserPostsViewModel()

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
        profileVM.getProfile(userId: uid)
        listUserPostsVM.getUserPosts(id: uid)
      }
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
      moreButton
    }
    .padding(.horizontal)
  }

  var bottomContent: some View {
    BottomSheet(detents: [.minimum, .large]) {
      ProfileView(
        user: user,
        isPresentingCover: $showingBusinessProfileCover
      )
    }
    .ignoresSafeArea(edges: .bottom)
  }

  var categories: some View {
    HStack {
      ForEach(user.categories, id: \.self) { category in
        TagView(tag: category)
      }
    }
  }
}

private extension PostDetailPage {
  var backButton: some View {
    CircleButton(systemName: "chevron.backward")
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
