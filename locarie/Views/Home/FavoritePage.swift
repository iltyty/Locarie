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
            BusinessMapAvatar(url: post.user.avatarUrl)
          }
        }
      }
      .onMapTapGesture { _ in
        moveBottomSheet(to: Constants.bottomDetent)
      }
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 205))
      .ignoresSafeArea()
      VStack(spacing: 0) {
        topContent.padding(.vertical, 8)
        Spacer()
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
          CircleButton(name: "Navigation")
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
          Image(systemName: "map")
            .resizable()
            .foregroundStyle(.white)
            .frame(width: 18, height: 18)
            .frame(width: 82, height: 40)
            .background {
              Capsule().fill(.black)
            }
            .padding(.bottom, 102)
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
            router.navigate(to: Router.Int64Destination.businessHome(user.id))
          },
          isPresenting: $presentingPostCover
        )
      }
      if presentingProfileCover {
        BusinessProfileCover(
          user: user,
          onAvatarTapped: {
            presentingProfileCover = false
            router.navigate(to: Router.Int64Destination.businessHome(user.id))
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
                NavigationLink(value: Router.Int64Destination.businessHome(vm.posts[i].user.id)) {
                  PostCardView(
                    vm.posts[i],
                    divider: i != vm.posts.count - 1,
                    onFullscreenTapped: {
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
                }
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
      CircleButton(systemName: "chevron.left").onTapGesture { dismiss() }
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
