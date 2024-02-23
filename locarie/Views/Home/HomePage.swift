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
        bottomSheetContent
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
      CircleButton(systemName: "bookmark")
    }
    .fontWeight(.semibold)
    .padding([.horizontal, .bottom])
  }

  var bottomSheetContent: some View {
    ScrollView {
      VStack {
        bottomSheetTitle
        postList
      }
    }
  }

  var bottomSheetTitle: some View {
    ZStack {
      Text("Discover this area")
        .fontWeight(.semibold)
        .padding(.bottom)
      HStack {
        Spacer()
        Link(destination: navigationUrl) {
          NavigationButton()
        }
      }
    }
  }

  var navigationUrl: URL {
    let coordinate = selectedPost.businessLocationCoordinate
    return URL(
      string: "https://www.google.com/maps?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=walking"
    )!
  }

  @ViewBuilder
  var postList: some View {
    if postVM.posts.isEmpty {
      Text("No post in this area.")
        .foregroundStyle(.secondary)
    } else {
      ForEach(postVM.posts) { post in
        NavigationLink {
          PostDetailPage(uid: post.user.id)
        } label: {
          PostCardView(post)
        }
        .tint(.primary)
        .buttonStyle(.plain)
      }
    }
  }
}

#Preview {
  HomePage()
}
