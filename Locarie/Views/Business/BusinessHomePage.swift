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
  var fullscreen = true
  let locationManager = LocationManager()

  @State private var viewport: Viewport = .camera(
    center: .london,
    zoom: Constants.mapZoom
  )

  @State private var user = UserDto()
  @State private var post = PostDto()
  @State private var favoredByCount = 0
  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent

  @State private var screenHeight: CGFloat = 0
  @State private var deltaLatitudeDegrees: CGFloat = 0
  @State private var mapUpperBoundY: CGFloat = 0
  @State private var mapBottomBoundY: CGFloat = 0

  @State private var profileCoverCurIndex = 0
  @State private var presentingPostCover = false
  @State private var presentingProfileCover = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var userListVM = UserListViewModel()
  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var listUserPostsVM = ListUserPostsViewModel()
  @StateObject private var favoritePostVM = FavoritePostViewModel()
  @StateObject private var favoriteBusinessVM = FavoriteBusinessViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .top) {
        mapView
        VStack(spacing: 0) {
          topContent
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
          bottomContent
          BusinessBottomBar(
            business: $user,
            favoriteBusinessVM: favoriteBusinessVM
          )
          .onReceive(favoriteBusinessVM.$state) { state in
            switch state {
            case .favoriteFinished:
              favoredByCount += 1
            case .unfavoriteFinished:
              favoredByCount -= 1
            default: break
            }
          }
        }
        if currentDetent == .large {
          VStack {
            Spacer()
            BackToMapButton()
              .padding(.bottom, BusinessBottomBarConstants.height + 24)
              .onTapGesture {
                moveBottomSheet(to: Constants.bottomDetent)
              }
          }
        }
        if presentingPostCover {
          PostCover(
            post: post,
            tags: user.categories,
            onAvatarTapped: {
              presentingPostCover = false
            },
            onPostDeleted: { id in
              listUserPostsVM.posts.removeAll { $0.id == id }
            },
            isPresenting: $presentingPostCover
          )
        }
        if presentingProfileCover {
          BusinessProfileCover(
            user: user,
            curIndex: profileCoverCurIndex,
            onAvatarTapped: {
              presentingProfileCover = false
            },
            isPresenting: $presentingProfileCover
          )
        }
      }
      .onAppear {
        screenHeight = proxy.size.height
        mapBottomBoundY = screenHeight - Constants.bottomY
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      if fullscreen {
        currentDetent = .large
      }
      profileVM.getProfile(userId: uid)
      listUserPostsVM.getUserPosts(id: uid)
      userListVM.listBusinesses()
    }
    .onReceive(profileVM.$dto) { dto in
      user = dto
      updateMapCenter(user: dto)
    }
    .onChange(of: user) { newUser in
      favoredByCount = newUser.favoredByCount
      listUserPostsVM.getUserPosts(id: newUser.id)
    }
  }

  private func moveBottomSheet(to detent: BottomSheetDetent) {
    withAnimation(.spring) {
      currentDetent = detent
    }
  }

  private func updateMapCenter(user: UserDto) {
    guard user.coordinate.latitude.isNormal, user.coordinate.longitude.isNormal else { return }
    let latitude = user.coordinate.latitude - deltaLatitudeDegrees *
      (screenHeight - mapUpperBoundY - mapBottomBoundY) /
      (2 * screenHeight)

    withViewportAnimation(.easeInOut(duration: 0.5)) {
      viewport = .camera(
        center: .init(latitude: latitude, longitude: user.coordinate.longitude),
        zoom: Constants.mapZoom
      )
    }
  }
}

private extension BusinessHomePage {
  var mapView: some View {
    MapReader { proxy in
      Map(viewport: $viewport) {
        ForEvery(userListVM.businesses) { u in
          MapViewAnnotation(coordinate: u.coordinate) {
            BusinessMapAvatar(url: u.avatarUrl, newUpdate: u.hasUpdateIn24Hours, amplified: u.id == user.id)
              .onTapGesture {
                user = u
              }
          }
          .allowOverlap(true)
          .allowOverlapWithPuck(true)
          .selected(u.id == user.id)
        }
      }
      .onMapTapGesture { _ in
        moveBottomSheet(to: Constants.bottomDetent)
      }
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: Constants.bottomY + 50))
      .onAppear {
        let bounds = proxy.map!.coordinateBounds(for: .init(cameraState: proxy.map!.cameraState))
        deltaLatitudeDegrees = bounds.north - bounds.south
      }
      .ignoresSafeArea(edges: .all)
    }
  }

  var topContent: some View {
    HStack(spacing: 10) {
      CircleButton("Chevron.Left").onTapGesture {
        dismiss()
      }
      Spacer()
      ShareLink(item: URL(string: "https://apps.apple.com/us/app/locarie/id6499185074")!, message: Text("Locarie")) {
        CircleButton("ShareIcon")
      }
    }
    .background {
      GeometryReader { proxy in
        Color.clear
          .task(id: proxy.frame(in: .global).maxY) {
            mapUpperBoundY = proxy.frame(in: .global).maxY
          }
      }
    }
  }

  var bottomContent: some View {
    BottomSheet(
      topPosition: .right,
      detents: [Constants.bottomDetent, .large],
      currentDetent: $currentDetent
    ) {
      VStack(alignment: .leading, spacing: 8) {
        Group {
          if case .loading = profileVM.state {
            BusinessUserProfilePage.avatarRowSkeleton
          } else {
            BusinessProfileAvatarRow(
              user: user,
              presentingCover: $presentingProfileCover
            )
          }
        }
        .padding(.horizontal, 16)
        ScrollViewReader { proxy in
          ScrollView {
            VStack(alignment: .leading, spacing: 16) {
              Group {
                if case .loading = profileVM.state {
                  BusinessUserProfilePage.categoriesSkeleton
                } else {
                  ProfileCategories(user).id(0)
                }
              }
              .padding(.horizontal, 16)
              Group {
                if case .loading = profileVM.state {
                  BusinessUserProfilePage.bioSkeleton
                } else {
                  ProfileBio(user)
                }
              }
              .padding(.horizontal, 16)
              ProfileDetail(user, favoredByCount: favoredByCount, likedCount: likedCount)
                .padding(.horizontal, 16)
              LocarieDivider().padding(.horizontal, 16)
              if case .finished = profileVM.state {
                ProfileImages(
                  user: user,
                  amplified: !listUserPostsVM.posts.isEmpty,
                  profileCoverCurIndex: $profileCoverCurIndex,
                  presentingProfileCover: $presentingProfileCover
                )
              }
              LocarieDivider().padding(.horizontal, 16)
              Group {
                if case .loading = listUserPostsVM.state {
                  BusinessUserProfilePage.postsSkeleton
                } else {
                  ProfilePostsCount(listUserPostsVM.posts)
                  postList
                }
              }
              .padding(.horizontal, 16)
            }
            .padding(.top, 8)
            .onChange(of: currentDetent) { _ in
              proxy.scrollTo(0)
            }
          }
        }
        .scrollIndicators(.hidden)
      }
    }
  }

  var likedCount: Int {
    listUserPostsVM.posts.map(\.favoredByCount).reduce(0, +)
  }

  @ViewBuilder
  var postList: some View {
    if listUserPostsVM.posts.isEmpty {
      HStack {
        Spacer()
        VStack {
          Image("NoPost").padding(.top, 40)
          Text("No post yet")
            .font(.custom(GlobalConstants.fontName, size: 14))
            .fontWeight(.bold)
        }
        Spacer()
      }
    } else {
      VStack(spacing: 0) {
        let posts = listUserPostsVM.posts
        ForEach(posts.indices, id: \.self) { i in
          let p = posts[i]
          PostCardView(
            p,
            divider: i != posts.count - 1,
            onCoverTapped: {
              post = p
              presentingPostCover = true
            },
            onThumbnailTapped: {
              presentingProfileCover = true
            }
          )
          .buttonStyle(.plain)
          .onTapGesture {
            post = p
            presentingPostCover = true
          }
        }
      }
    }
  }

  var updatedIn24Hours: Bool {
    !listUserPostsVM.posts.isEmpty &&
      Date().timeIntervalSince(listUserPostsVM.posts[0].time) < 86400
  }
}

private extension BusinessHomePage {
  func toggleShowingBusinessProfileCover() {
    withAnimation(.spring) {
      presentingProfileCover.toggle()
    }
  }

  func toggleShowingPostContentCover() {
    withAnimation(.spring) {
      presentingPostCover.toggle()
    }
  }
}

private extension BusinessHomePage {
  var skeleton: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 10) {
        RoundedAvatarSkeletonView()
        VStack(alignment: .leading, spacing: 10) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      HStack(spacing: 5) {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
        Spacer()
      }
      SkeletonView(48, 10)
    }
  }
}

private enum Constants {
  static let bottomY: CGFloat = 197
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(bottomY)
  static let vSpacing: CGFloat = 15
  static let mapZoom: CGFloat = 16
}

#Preview {
  BusinessHomePage(uid: 53, fullscreen: false)
}
