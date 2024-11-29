//
//  BusinessUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 07/01/2024.
//

import Kingfisher
@_spi(Experimental) import MapboxMaps
import SwiftUI

struct BusinessUserProfilePage: View {
  @State var screenSize: CGSize = .zero

  @State private var avatarId = ""
  
  @State private var prePostIndex = 0
  @State private var shouldFetchPost = false

  @State private var viewport: Viewport = .camera(center: .london, zoom: Constants.mapZoom)
  @State private var post = PostDto()
  @State private var currentDetent: BottomSheetDetent = .large

  @State private var deltaLatitudeDegrees: CGFloat = 0
  @State private var mapUpperBoundY: CGFloat = 0
  @State private var mapBottomBoundY: CGFloat = 0

  @State private var profileCoverCurIndex = 0
  @State private var presentingDeletePostDialog = false
  @State private var presentingNotPublicSheet = false
  @State private var presentingProfileCover = false
  @State private var presentingPostCover = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var postVM = ListUserPostsViewModel()
  @StateObject private var postDeleteVM = PostDeleteViewModel()
  
  private let scrollViewCoordinateSpace = "scrollView"

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .bottom) {
        VStack(spacing: 0) {
          ZStack {
            mapView
            contentView
          }
          BottomTabView()
        }
        VStack {
          Spacer()
          ZStack {
            if currentDetent == .large {
              BackToMapButton()
                .onTapGesture {
                  moveBottomSheet(to: Constants.bottomDetent)
                }
            }
            if !cacheVM.cache.profileComplete {
              HStack {
                Spacer()
                NotPublicButton().onTapGesture {
                  presentingNotPublicSheet = true
                }
              }
              .padding(.horizontal, 24)
            }
          }
          .padding(.bottom, BottomTabConstants.height + 24)
        }
        if presentingPostCover {
          ImagesFullScreenCover(
            index: profileCoverCurIndex,
            imageUrls: post.imageUrls,
            isPresenting: $presentingPostCover
          )
        }
        if presentingProfileCover {
          ImagesFullScreenCover(
            index: profileCoverCurIndex,
            imageUrls: profileVM.dto.profileImageUrls,
            isPresenting: $presentingProfileCover
          )
        }
      }
      .sheet(isPresented: $presentingNotPublicSheet) {
        Group {
          if #available(iOS 16.4, *) {
            NotPublicSheetView(user: profileVM.dto).presentationCornerRadius(24)
          } else {
            NotPublicSheetView(user: profileVM.dto)
          }
        }
        .presentationDetents([.height(450)])
      }
      .onAppear {
        screenSize = proxy.size
        mapBottomBoundY = screenSize.height - Constants.bottomY

        profileVM.getProfile(userId: userId)
        
        postVM.reset()
        postVM.getUserPosts(id: userId)
      }
      .onDisappear {
        presentingNotPublicSheet = false
      }
    }
    .alert("Confirm deletion", isPresented: $presentingDeletePostDialog) {
      Button("Delete", role: .destructive) {
        postDeleteVM.delete(id: post.id)
      }
    }
    .onChange(of: shouldFetchPost) { _ in
      postVM.getUserPosts(id: userId)
    }
    .onReceive(profileVM.$state) { state in
      if case .finished = state {
        // for debug use, if all users have re-logged in, this line can be deleted
        // because in previous version, the email is not cached, only new version
        // users have their email cached after logged in. Thus, we should cache the
        // email here for use of resetting password (see ChangePasswordPage)
        cacheVM.setEmail(profileVM.dto.email)
        cacheVM.setProfileComplete(profileVM.dto.isProfileComplete)
        if cacheVM.isFirstLoggedIn(), !cacheVM.isProfileComplete() {
          presentingNotPublicSheet = true
        }
        updateMapCenter(user: profileVM.dto)
      }
    }
    .onReceive(postDeleteVM.$state) { state in
      switch state {
      case .finished:
        postVM.posts.removeAll { $0.id == post.id }
      default: return
      }
    }
    .onReceive(cacheVM.$cache) { cache in
      avatarId = cache.avatarId
    }
    .ignoresSafeArea(edges: .bottom)
  }

  private var userId: Int64 {
    cacheVM.getUserId()
  }

  private func moveBottomSheet(to detent: BottomSheetDetent) {
    withAnimation(.spring) {
      currentDetent = detent
    }
  }

  private func updateMapCenter(user: UserDto) {
    guard user.coordinate.latitude.isNormal, user.coordinate.longitude.isNormal else { return }
    let latitude = user.coordinate.latitude - deltaLatitudeDegrees *
      (screenSize.height - mapUpperBoundY - mapBottomBoundY) /
      (2 * screenSize.height)

    withViewportAnimation(.easeInOut(duration: 0.5)) {
      viewport = .camera(
        center: .init(latitude: latitude, longitude: user.coordinate.longitude),
        zoom: Constants.mapZoom
      )
    }
  }
}

private extension BusinessUserProfilePage {
  var mapView: some View {
    MapReader { proxy in
      Map(viewport: $viewport) {
        MapViewAnnotation(coordinate: profileVM.dto.coordinate) {
          BusinessMapAvatar(url: profileVM.dto.avatarUrl, newUpdate: profileVM.dto.hasUpdateIn24Hours, amplified: true)
            .id(avatarId)
            .onTapGesture {
              updateMapCenter(user: profileVM.dto)
            }
        }
      }
      .mapStyle(MapStyle(uri: StyleURI(rawValue: GlobalConstants.mapStyleURI)!))
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: Constants.bottomY))
      .ignoresSafeArea(edges: .all)
      .onAppear {
        let bounds = proxy.map!.coordinateBounds(for: .init(cameraState: proxy.map!.cameraState))
        deltaLatitudeDegrees = bounds.north - bounds.south
      }
      .onTapGesture {
        withAnimation(.spring) {
          currentDetent = Constants.bottomDetent
        }
      }
    }
  }
}

private extension BusinessUserProfilePage {
  var contentView: some View {
    VStack(spacing: 0) {
      buttons.padding(.vertical, 8)
      BottomSheet(
        topPosition: .right,
        detents: [Constants.bottomDetent, .large],
        currentDetent: $currentDetent
      ) {
        sheetContent
      }
    }
  }

  var sheetContent: some View {
    VStack(alignment: .leading, spacing: 8) {
      Group {
        if case .loading = profileVM.state {
          BusinessUserProfilePage.avatarRowSkeleton
        } else {
          BusinessProfileAvatarRow(
            user: profileVM.dto,
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
                ProfileCategories(profileVM.dto).id(0)
              }
            }
            .padding(.horizontal, 16)
            if case .loading = profileVM.state {
              BusinessUserProfilePage.bioSkeleton.padding(.horizontal, 16)
            } else {
              Group {
                if cacheVM.cache.profileComplete {
                  ProfileBio(profileVM.dto)
                } else {
                  Text("""
                  Not Public Yet…
                  Your profile is only a few steps away from going public. \
                  Complete your profile to start connecting with customers!
                  """)
                  .foregroundStyle(LocarieColor.greyDark)
                }
              }
              .padding(.horizontal, 16)
              ProfileDetail(profileVM.dto, favoredByCount: profileVM.dto.favoredByCount, likedCount: likedCount)
                .padding(.horizontal, 16)
              LocarieDivider().padding(.horizontal, 16)
              if case .finished = profileVM.state {
                ProfileImages(
                  user: profileVM.dto,
                  amplified: postVM.posts.isEmpty,
                  profileCoverCurIndex: $profileCoverCurIndex,
                  presentingProfileCover: $presentingProfileCover
                )
                if !profileVM.dto.profileImageUrls.isEmpty {
                  LocarieDivider().padding(.horizontal, 16)
                }
              }
            }
            Group {
              if case .loading = postVM.state {
                BusinessUserProfilePage.postsSkeleton
              } else {
                ProfilePostsCount(postVM.posts)
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
        .scrollIndicators(.hidden)
      }
    }
  }

  var likedCount: Int {
    postVM.posts.map(\.favoredByCount).reduce(0, +)
  }

  @ViewBuilder
  var postList: some View {
    if postVM.posts.isEmpty {
      HStack {
        Spacer()
        VStack {
          Image("NoPost").padding(.top, 40)
          Text("Start Posting")
            .font(.custom(GlobalConstants.fontName, size: 14))
            .fontWeight(.bold)
        }
        .padding(.bottom, 80)
        Spacer()
      }
    } else {
      VStack(spacing: 0) {
        ForEach(postVM.posts.indices, id: \.self) { i in
          let p = postVM.posts[i]
          PostCardView(
            p,
            divider: true,
            deletable: true,
            bottomPadding: i == postVM.posts.count - 1 ? .large : .small,
            onCoverTapped: {
              post = p
              presentingPostCover = true
            },
            onThumbnailTapped: {
              presentingProfileCover = true
            },
            presentingDeleteDialog: $presentingDeletePostDialog,
            deleteTargetPost: $post
          )
          .id(avatarId)
          .buttonStyle(.plain)
          .onTapGesture {
            post = p
            presentingPostCover = true
          }
        }
        .background {
          GeometryReader { proxy in
            Color.clear.preference(key: PostViewOffsetKey.self, value: -(proxy.frame(in: .named(scrollViewCoordinateSpace)).origin.y - 16))
          }
        }
        .onPreferenceChange(PostViewOffsetKey.self) { offset in
          let i = Int(offset) / GlobalConstants.postCardHeight
          if i <= prePostIndex {
            prePostIndex = i
            return
          }
          prePostIndex = i
          let delta = postVM.posts.count - Constants.postFetchThreshold
          if delta <= 0 || i == delta || i == postVM.posts.count {
            shouldFetchPost.toggle()
          }
        }
      }
    }
  }

  var buttons: some View {
    HStack(spacing: 16) {
      mineButton
      Spacer()
      ZStack(alignment: .topTrailing) {
        ProfileEditButton()
        if !cacheVM.cache.profileComplete {
          Circle()
            .fill(LocarieColor.primary)
            .frame(size: 10)
        }
      }
      settingsButton
    }
    .padding(.horizontal, 16)
    .background {
      GeometryReader { proxy in
        Color.clear.onAppear {
          mapUpperBoundY = proxy.frame(in: .global).maxY
        }
      }
    }
  }

  var mineButton: some View {
    NavigationLink(value: Router.Destination.regularUserProfile) {
      ZStack {
        Circle()
          .fill(Color(hex: 0xF0F0F0))
          .frame(size: Constants.topButtonSize)
          .shadow(radius: 2)
        if cacheVM.getAvatarUrl().isEmpty {
          defaultAvatar(size: Constants.topButtonSize - 2 * Constants.topButtonStrokeWidth)
        } else {
          KFImage(URL(string: cacheVM.getAvatarUrl()))
            .placeholder {
              SkeletonView(
                Constants.topButtonSize - 2 * Constants.topButtonStrokeWidth,
                Constants.topButtonSize - 2 * Constants.topButtonStrokeWidth,
                true
              )
            }
            .resizable()
            .frame(size: Constants.topButtonSize - 2 * Constants.topButtonStrokeWidth)
            .clipShape(Circle())
        }
      }
    }
    .id(avatarId)
  }

  var settingsButton: some View {
    NavigationLink(value: Router.Destination.settings) {
      Image("GearShape")
        .frame(size: Constants.topButtonSize)
        .background(Circle().fill(.background).shadow(radius: 2))
    }
    .buttonStyle(.plain)
  }
}

private extension BusinessUserProfilePage {
  struct PostViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
  }
}

private enum Constants {
  static let bottomY: CGFloat = 212
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(bottomY)

  static let dialogBgOpacity: CGFloat = 0.2
  static let dialogAnimationDuration: CGFloat = 1

  static let mapZoom: CGFloat = 16
  static let buttonShadowRadius: CGFloat = 2.0

  static let topButtonSize: CGFloat = 40
  static let topButtonStrokeWidth: CGFloat = 3
  static let topButtonIconSize: CGFloat = 18
  
  static let postFetchThreshold = 5
}

#Preview {
  BusinessUserProfilePage()
}
