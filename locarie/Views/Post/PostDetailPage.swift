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
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)

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
                zoom: 12
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
      VStack(alignment: .leading) {
        profile
        categories
        if showingDetailedProfile {
          detailedProfile
        }
        posts
      }
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
  var profile: some View {
    HStack {
      avatar
      nameAndNeighborhood
      Spacer()
      profileButton
    }
  }

  var avatar: some View {
    AvatarView(imageUrl: user.avatarUrl, size: Constants.avatarSize)
      .onTapGesture {
        toggleShowingBusinessProfileCover()
      }
  }

  var nameAndNeighborhood: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      Text(user.businessName)
      Text("Marylebone")
    }
  }

  var profileButton: some View {
    Text(showingDetailedProfile ? "Hide profile" : "See profile")
      .foregroundStyle(.secondary)
      .background(Capsule().fill(.background))
      .onTapGesture {
        withAnimation(.spring) {
          showingDetailedProfile.toggle()
        }
      }
  }
}

private extension PostDetailPage {
  var detailedProfile: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      bio
      favoriteCount
      address
      openUntil
      seeAllButton
    }
  }

  var bio: some View {
    Text(user.introduction)
  }

  var favoriteCount: some View {
    Label("26", systemImage: "bookmark")
  }

  var address: some View {
    Label(user.address, systemImage: "map")
  }

  var openUntil: some View {
    Label(user.openUtil, systemImage: "clock")
  }

  var seeAllButton: some View {
    Label("See all", systemImage: "text.justify")
      .foregroundStyle(.secondary)
  }
}

private extension PostDetailPage {
  var posts: some View {
    ScrollView {
      VStack {
        ForEach(listUserPostsVM.posts) { post in
          PostCardView(post)
            .onTapGesture {
              self.post = post
              toggleShowingPostContentCover()
            }
        }
      }
    }
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
  static let avatarSize = 72.0
  static let vSpacing = 15.0
  static let profileCoverImageWidthProportion = 0.9
  static let profileCoverImageHeightProportion = 0.3
  static let postCoverImageWidthProportion = 0.9
  static let postCoverImageHeightProportion = 0.6
}

#Preview {
  PostDetailPage(uid: 1)
}
