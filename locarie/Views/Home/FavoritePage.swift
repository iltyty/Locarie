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
  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)
  @State private var currentDetent: BottomSheetDetent = Constants.mediumDetent

  @StateObject private var vm = FavoritePostViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    ZStack {
      StaticPostsMapView(posts: vm.posts, selectedPost: $selectedPost)
      VStack(spacing: 0) {
        topContent
        Spacer()
        BottomSheet(
          topPosition: .right,
          detents: [Constants.bottomDetent, Constants.mediumDetent, .large],
          currentDetent: $currentDetent
        ) {
          VStack {
            Text("Following")
              .font(.custom(GlobalConstants.fontName, size: 18))
              .fontWeight(.bold)
              .padding(.bottom, 24)
            PostList(
              posts: vm.posts,
              scrollId: $scrollId,
              showTitle: false,
              emptyHint: "No followed post."
            )
          }
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
      }
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      vm.list(userId: LocalCacheViewModel.shared.getUserId())
    }
    .onReceive(vm.$posts) { posts in
      selectedPost = posts.first ?? PostDto()
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
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(117)
  static let mediumDetent: BottomSheetDetent = .absoluteBottom(378)
}

#Preview {
  FavoritePage()
}
