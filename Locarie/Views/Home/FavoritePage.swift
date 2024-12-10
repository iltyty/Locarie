//
//  FavoritePage.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct FavoritePage: View {
  private let router = Router.shared
  private let cacheVM = LocalCacheViewModel.shared

  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)
  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent
  
  @State private var prePostIndex = 0
  @State private var shouldFetchPost = false

  @State private var post = PostDto()
  @State private var user = UserDto()
  @State private var presentingPostCover = false
  @State private var presentingProfileCover = false

  // TODO: pagination
  @StateObject private var vm = FavoriteBusinessViewModel(userSize: 1000)

  @Environment(\.dismiss) var dismiss
  
  private let scrollViewCoordinateSpace = "scrollView"

  var body: some View {
    ZStack {
      Map(viewport: $viewport) {
        Puck2D()

        ForEvery(vm.users) { user in
          MapViewAnnotation(coordinate: user.coordinate) {
            NavigationLink(
              value: Router.BusinessHomeDestination.businessHome(
                user.id,
                user.location?.latitude ?? CLLocationCoordinate2D.london.latitude,
                user.location?.longitude ?? CLLocationCoordinate2D.london.longitude,
                false
              )
            ) {
              BusinessMapAvatar(url: user.avatarUrl, newUpdate: user.hasUpdateIn24Hours)
            }
          }
          .allowOverlap(true)
          .allowOverlapWithPuck(true)
        }
      }
      .mapStyle(MapStyle(uri: StyleURI(rawValue: GlobalConstants.mapStyleURI)!))
      .onMapTapGesture { _ in
        moveBottomSheet(to: Constants.bottomDetent)
      }
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 205))
      .ignoresSafeArea()
      VStack(spacing: 0) {
        topContent.padding(.vertical, 8)
        BottomSheet(
          topPosition: .right,
          detents: [Constants.bottomDetent, .large],
          currentDetent: $currentDetent
        ) {
          Group {
            if case .loading = vm.state {
              VStack {
                PostCardView.skeleton
                PostCardView.skeleton
              }
            } else {
              postList
            }
          }
          .allowsHitTesting(currentDetent != Constants.bottomDetent)
          .padding(.horizontal, 16)
        } topContent: {
          CircleButton("Navigation")
            .padding(.trailing, 16)
            .onTapGesture {
              withViewportAnimation(.fly) {
                viewport = .followPuck(zoom: GlobalConstants.mapZoom)
              }
            }
        }
        BottomTabView()
      }
      if currentDetent == .large {
        VStack {
          Spacer()
          BackToMapButton()
            .padding(.bottom, BottomTabConstants.height + 24)
            .onTapGesture {
              moveBottomSheet(to: Constants.bottomDetent)
            }
        }
      }
      if presentingPostCover {
        ImagesFullScreenCover(
          index: 0,
          imageUrls: post.imageUrls,
          isPresenting: $presentingPostCover
        )
      }
      if presentingProfileCover {
        ImagesFullScreenCover(
          index: 0,
          imageUrls: user.profileImageUrls,
          isPresenting: $presentingProfileCover
        )
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      vm.list(userId: cacheVM.getUserId())
      vm.listFavoriteBusinessPosts(userId: cacheVM.getUserId())
    }
    .onChange(of: shouldFetchPost) { _ in
      vm.listFavoriteBusinessPosts(userId: cacheVM.getUserId())
    }
  }

  private var postList: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("Following")
          .id(-1)
          .font(.custom(GlobalConstants.fontName, size: 18))
          .fontWeight(.bold)
        if vm.posts.isEmpty {
          emptyList
        } else {
          VStack(spacing: 0) {
            ForEach(vm.posts.indices, id: \.self) { i in
              PostCardView(
                vm.posts[i],
                divider: true,
                bottomPadding: i == vm.posts.count - 1 ? .large : .small,
                onTapped: {
                  router.navigate(to: Router.BusinessHomeDestination.businessHome(
                    vm.posts[i].user.id,
                    user.location?.latitude ?? CLLocationCoordinate2D.london.latitude,
                    user.location?.longitude ?? CLLocationCoordinate2D.london.longitude,
                    true)
                  )
                },
                onCoverTapped: {
                  post = vm.posts[i]
                  user = post.user
                  presentingPostCover = true
                },
                onThumbnailTapped: {
                  post = vm.posts[i]
                  user = post.user
                  presentingProfileCover = true
                }
              )
              .id(i)
              .tint(.primary)
              .buttonStyle(.plain)
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
              let delta = vm.posts.count - 5
              if delta <= 0 || i == delta || i == vm.posts.count {
                shouldFetchPost.toggle()
              }
            }
          }
        }
      }
    }
    .scrollIndicators(.hidden)
  }

  private var emptyList: some View {
    VStack {
      Image("NoPost")
        .resizable()
        .scaledToFit()
        .frame(size: 72)
      Text("No moments yet")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
    }
    .padding(.top, 45)
    .padding(.bottom, 16)
  }

  private func moveBottomSheet(to detent: BottomSheetDetent) {
    withAnimation(.spring) {
      currentDetent = detent
    }
  }
}

private extension FavoritePage {
  var topContent: some View {
    HStack {
      CircleButton("Chevron.Left").onTapGesture { dismiss() }
      Spacer()
    }
    .padding(.horizontal, 16)
  }
}

private extension FavoritePage {
  struct PostViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
      value += nextValue()
    }
  }
}

private enum Constants {
  static let bottomY: CGFloat = 205
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(bottomY)
}

#Preview {
  FavoritePage()
}
