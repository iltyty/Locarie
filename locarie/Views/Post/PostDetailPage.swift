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
  @StateObject private var postVM = PostListNearbyViewModel()

  @State private var screenSize: CGSize = .zero
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)
  @State private var user = UserDto()

  @State private var showingDetailedProfile = false
  @State private var showingPostContentCover = false
  @State private var showingBusinessProfileCover = false

  let uid: Int64
  let locationManager = LocationManager()

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(
      from: CLLocation(
        latitude: user.location?.latitude ?? 0,
        longitude: user.location?.longitude ?? 0
      )
    )
  }

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .top) {
        mapView
        content
        if showingBusinessProfileCover {
          businessProfileCover
        }
        if showingPostContentCover {
          postContentCover
        }
      }
      .onAppear {
        screenSize = proxy.size
        profileVM.getProfile(userId: uid)
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

      ForEvery(postVM.posts) { post in
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
        tags
        if showingDetailedProfile {
          detailedProfile
        }
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
        showingDetailedProfile.toggle()
      }
  }
}

private extension PostDetailPage {
  var tags: some View {
    HStack {
      TagView(tag: "Food & Drink", isSelected: false)
      TagView(tag: "Shop", isSelected: false)
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
  var businessProfileCover: some View {
    VStack(alignment: .leading) {
      coverTopBar
      Spacer()
      profileImages
      coverBottom
      Spacer()
    }
    .padding(.horizontal)
    .background(.thickMaterial.opacity(Constants.coverBackgroundOpacity))
    .contentShape(Rectangle())
    .onTapGesture {
      toggleShowingBusinessProfileCover()
    }
  }

  var profileImages: some View {
    HStack {
      Banner(
        urls: user.profileImageUrls,
        width: screenSize.width * Constants.profileCoverImageWidthProportion,
        height: screenSize.height * Constants.profileCoverImageHeightProportion,
        rounded: true
      )
    }
    .padding(.bottom)
  }
}

private extension PostDetailPage {
  var postContentCover: some View {
    VStack(alignment: .leading) {
      coverTopBar
      Spacer()
      coverBottom
    }
    .padding(.horizontal)
    .presentationBackground(.ultraThinMaterial)
    .onTapGesture {
      toggleShowingPostContentCover()
    }
  }
}

private extension PostDetailPage {
  func toggleShowingBusinessProfileCover() {
    withAnimation(.spring) {
      showingBusinessProfileCover.toggle()
    }
  }

  func toggleShowingPostContentCover() {
    withTransaction(coverTransaction) {
      showingPostContentCover.toggle()
    }
  }

  var coverTransaction: Transaction {
    var transaction = Transaction()
    transaction.disablesAnimations = true
    transaction.animation = .linear(duration: 0.5)
    return transaction
  }
}

private extension PostDetailPage {
  var coverTopBar: some View {
    HStack {
      coverDismissButton
      coverAvatar
      coverBusinessName
      Spacer()
      coverMoreButton
    }
  }

  var coverDismissButton: some View {
    Image(systemName: "multiply")
      .font(.system(size: Constants.coverDismissButtonSize))
  }

  var coverAvatar: some View {
    AvatarView(imageUrl: user.avatarUrl, size: Constants.coverAvatarSize)
  }

  var coverBusinessName: some View {
    Text(user.businessName).fontWeight(.semibold)
  }

  var coverMoreButton: some View {
    Image(systemName: "ellipsis")
      .font(.system(size: Constants.coverDismissButtonSize))
  }
}

private extension PostDetailPage {
  var coverBottom: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      tags
      address
      openUntil
    }
  }
}

private enum Constants {
  static let avatarSize = 72.0
  static let vSpacing = 15.0
  static let coverDismissButtonSize = 36.0
  static let coverAvatarSize = 40.0
  static let coverBackgroundOpacity = 0.95
  static let profileCoverImageWidthProportion = 0.9
  static let profileCoverImageHeightProportion = 0.3
  static let postCoverImageWidthProportion = 0.9
  static let postCoverImageHeightProportion = 0.6
}

#Preview {
  PostDetailPage(uid: 1)
}
