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
      contentView
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
  var contentView: some View {
    VStack(spacing: 0) {
      topContent
      Spacer()
      BottomSheet(
        detents: [Constants.bottomDetent, Constants.mediumDetent, .large],
        currentDetent: $currentDetent
      ) {
        PostList(
          posts: vm.posts,
          scrollId: $scrollId,
          showTitle: false,
          emptyHint: "No followed post."
        )
      }
    }
  }

  var topContent: some View {
    ZStack {
      HStack {
        Spacer()
        CapsuleButton { Label("Following", systemImage: "bookmark") }
        Spacer()
      }
      HStack {
        CircleButton(systemName: "chevron.left").onTapGesture { dismiss() }
        Spacer()
      }
    }
    .fontWeight(.semibold)
    .padding([.horizontal, .bottom])
  }
}

private enum Constants {
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(0)
  static let mediumDetent: BottomSheetDetent = .absoluteBottom(220)
}

#Preview {
  FavoritePage()
}
