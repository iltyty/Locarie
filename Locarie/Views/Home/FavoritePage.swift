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

  @State private var scrollId: Int64? = nil
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)
  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent

  @State private var post = PostDto()
  @State private var user = UserDto()
  @State private var presentingPostCover = false
  @State private var presentingProfileCover = false

  @StateObject private var vm = FavoriteBusinessViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    ZStack {
      Map(viewport: $viewport) {
        Puck2D()

        ForEvery(vm.posts) { post in
          MapViewAnnotation(coordinate: post.user.coordinate) {
            BusinessMapAvatar(url: post.user.avatarUrl, newUpdate: post.user.hasUpdateIn24Hours)
          }
          .allowOverlap(true)
          .allowOverlapWithPuck(true)
        }
      }
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
        PostCover(
          post: post,
          tags: post.user.categories,
          onAvatarTapped: {
            presentingPostCover = false
            router.navigate(to: Router.Int64Destination.businessHome(user.id, true))
          },
          isPresenting: $presentingPostCover
        )
      }
      if presentingProfileCover {
        BusinessProfileCover(
          user: user,
          onAvatarTapped: {
            presentingProfileCover = false
            router.navigate(to: Router.Int64Destination.businessHome(user.id, true))
          },
          isPresenting: $presentingProfileCover
        )
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      vm.listFavoriteBusinessPosts(userId: LocalCacheViewModel.shared.getUserId())
    }
  }

  private var postList: some View {
    ScrollViewReader { proxy in
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
                  divider: i != vm.posts.count - 1,
                  onTapped: {
                    router.navigate(to: Router.Int64Destination.businessHome(vm.posts[i].user.id, true))
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
            }
          }
        }
        .onChange(of: scrollId) { _ in
          proxy.scrollTo(0)
          scrollId = 1
        }
      }
    }
    .scrollIndicators(.hidden)
  }

  private var emptyList: some View {
    VStack {
      Image("NoBusiness")
      Text("No business yet")
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
        .foregroundStyle(LocarieColor.greyDark)
    }
    .padding(.top, 45)
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

private enum Constants {
  static let bottomY: CGFloat = 205
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(bottomY)
}

#Preview {
  FavoritePage()
}
