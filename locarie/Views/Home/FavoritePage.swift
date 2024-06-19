//
//  FavoritePage.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct FavoritePage: View {
  @State private var scrollId: Int64? = nil
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)
  @State private var currentDetent: BottomSheetDetent = Constants.bottomDetent

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
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 205))
      .ignoresSafeArea()
      VStack(spacing: 0) {
        topContent
        Spacer()
        BottomSheet(
          topPosition: .right,
          detents: [Constants.bottomDetent, .large],
          currentDetent: $currentDetent
        ) {
          PostList(
            posts: vm.posts,
            scrollId: $scrollId,
            title: "Following",
            emptyHint: "No followed post."
          )
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
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      vm.listFavoriteBusinessPosts(userId: LocalCacheViewModel.shared.getUserId())
    }
  }
}

private extension FavoritePage {
  var topContent: some View {
    HStack {
      CircleButton(systemName: "chevron.left").onTapGesture { dismiss() }
      Spacer()
    }
    .padding(.bottom, 8)
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
