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

  @State private var viewport: Viewport = .camera(center: .london, zoom: Constants.mapZoom)
  @State private var post = PostDto()
  @State private var currentDetent: BottomSheetDetent = .large

  @State private var deltaLatitudeDegrees: CGFloat = 0
  @State private var mapUpperBoundY: CGFloat = 0
  @State private var mapBottomBoundY: CGFloat = 0

  @State private var presentingDeletePostDialog = false
  @State private var presentingNotPublicSheet = false
  @State private var presentingProfileDetail = true
  @State private var presentingProfileCover = false
  @State private var presentingPostCover = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @StateObject private var profileVM = ProfileGetViewModel()
  @StateObject private var postVM = ListUserPostsViewModel()
  @StateObject private var postDeleteVM = PostDeleteViewModel()

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
          .padding(.bottom, 102)
        }
        if presentingProfileCover {
          BusinessProfileCover(
            user: profileVM.dto,
            onAvatarTapped: {
              presentingProfileCover = false
            },
            isPresenting: $presentingProfileCover
          )
        }
        if presentingPostCover {
          PostCover(
            post: post,
            tags: profileVM.dto.categories,
            onAvatarTapped: {
              presentingPostCover = false
            },
            onPostDeleted: { id in
              postVM.posts.removeAll { $0.id == id }
            },
            isPresenting: $presentingPostCover
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
        if cacheVM.isFirstLoggedIn(), !cacheVM.cache.profileComplete {
          presentingNotPublicSheet = true
        }
        screenSize = proxy.size
        mapBottomBoundY = screenSize.height - Constants.bottomY

        profileVM.getProfile(userId: userId)
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
    .onReceive(profileVM.$state) { state in
      if case .finished = state {
        cacheVM.setProfileComplete(profileVM.dto.isProfileComplete)
      }
    }
    .onReceive(profileVM.$dto) { dto in
      if cacheVM.isFirstLoggedIn(), !cacheVM.isProfileComplete() {
        presentingNotPublicSheet = true
      }
      updateMapCenter(user: dto)
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
          BusinessMapAvatar(url: profileVM.dto.avatarUrl)
            .id(avatarId)
            .onTapGesture {
              updateMapCenter(user: profileVM.dto)
            }
        }
      }
      .gestureOptions(disabledAllGesturesOptions())
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
        Group {
          if case .loading = profileVM.state {
            BusinessUserProfilePage.skeleton
          } else {
            sheetContent
          }
        }
        .padding(.horizontal, 16)
      }
    }
  }

  var sheetContent: some View {
    VStack(alignment: .leading, spacing: 8) {
      BusinessProfileAvatarRow(
        user: profileVM.dto,
        presentingCover: $presentingProfileCover,
        presentingDetail: $presentingProfileDetail
      )
      ScrollViewReader { proxy in
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            ProfileCategories(profileVM.dto).id(0)
            if cacheVM.cache.profileComplete {
              ProfileBio(profileVM.dto, presentingDetail: $presentingProfileDetail)
            } else {
              Text("""
              Not Public Yet…
              Your profile is only a few steps away from going public. \
              Complete your profile to start connecting with customers
              """)
              .foregroundStyle(LocarieColor.greyDark)
            }
            if presentingProfileDetail {
              ProfileDetail(profileVM.dto)
            }
            ProfilePostsCount(postVM.posts)
            postList
          }
          .padding(.top, 8)
          .onChange(of: currentDetent) { _ in
            proxy.scrollTo(0)
          }
          .onChange(of: presentingProfileDetail) { presenting in
            if presenting {
              proxy.scrollTo(0)
            }
          }
        }
        .scrollIndicators(.hidden)
      }
    }
  }

  @ViewBuilder
  var postList: some View {
    if postVM.posts.isEmpty {
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
        ForEach(postVM.posts.indices, id: \.self) { i in
          let p = postVM.posts[i]
          PostCardView(
            p,
            divider: i != postVM.posts.count - 1,
            deletable: true,
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
            .frame(width: 10, height: 10)
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
          .frame(width: Constants.topButtonSize, height: Constants.topButtonSize)
          .shadow(radius: 2)
        if cacheVM.getAvatarUrl().isEmpty {
          defaultAvatar(size: Constants.topButtonSize - 4)
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
            .frame(
              width: Constants.topButtonSize - 2 * Constants.topButtonStrokeWidth,
              height: Constants.topButtonSize - 2 * Constants.topButtonStrokeWidth
            )
            .clipShape(Circle())
        }
      }
    }
    .id(avatarId)
  }

  var settingsButton: some View {
    NavigationLink(value: Router.Destination.settings) {
      Image("GearShape")
        .frame(width: Constants.topButtonSize, height: Constants.topButtonSize)
        .background(Circle().fill(.background).shadow(radius: 2))
    }
    .buttonStyle(.plain)
  }
}

private enum Constants {
  static let bottomY: CGFloat = 184
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(bottomY)

  static let dialogBgOpacity: CGFloat = 0.2
  static let dialogAnimationDuration: CGFloat = 1

  static let mapZoom: CGFloat = 16
  static let buttonShadowRadius: CGFloat = 2.0

  static let topButtonSize: CGFloat = 40
  static let topButtonStrokeWidth: CGFloat = 2
  static let topButtonIconSize: CGFloat = 18
}

#Preview {
  BusinessUserProfilePage()
}
