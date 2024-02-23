//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct HomePage: View {
  @StateObject private var postVM = PostListNearbyViewModel()
  @StateObject private var neighborVM = NeighborhoodLookupViewModel()

  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)

  var body: some View {
    ZStack {
      DynamicPostsMapView(
        selectedPost: $selectedPost,
        neighborVM: neighborVM,
        postVM: postVM
      )
      contentView
    }
    .ignoresSafeArea(edges: .bottom)
    .onReceive(postVM.$posts) { posts in
      selectedPost = posts.first ?? PostDto()
    }
  }
}

private extension HomePage {
  var contentView: some View {
    VStack(spacing: 0) {
      topContent
      Spacer()
      BottomSheet(detents: [.minimum, .large]) {
        PostList(posts: postVM.posts, selectedPost: $selectedPost)
      }
      BottomTabView().background(.background)
    }
  }

  var topContent: some View {
    HStack {
      CircleButton(systemName: "magnifyingglass")
      Spacer()
      CapsuleButton {
        Label(neighborVM.neighborhood, image: "BlueMap")
      }
      Spacer()
      NavigationLink(value: Router.Destination.favorite) {
        CircleButton(systemName: "bookmark")
      }
      .tint(.primary)
      .buttonStyle(.plain)
    }
    .fontWeight(.semibold)
    .padding([.horizontal, .bottom])
  }
}

#Preview {
  HomePage()
}
