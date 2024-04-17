//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct HomePage: View {
  @StateObject private var postVM = PostListWithinViewModel()
  @StateObject private var neighborVM = PlaceReverseViewModel()

  @State private var searching = false
  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport =
    .camera(center: .london, zoom: GlobalConstants.mapZoom)

  @Namespace var namespace

  var body: some View {
    ZStack {
      DynamicPostsMapView(
        viewport: $viewport,
        selectedPost: $selectedPost,
        neighborVM: neighborVM,
        postVM: postVM
      )
      contentView
      VStack { // ensure zIndex of all views keep the same
        if searching {
          BusinessSearchView(searching: $searching)
        }
      }
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
      buttons
      BottomSheet(
        topPosition: .right,
        detents: [.absoluteBottom(45), .absoluteBottom(150), .absoluteTop(150)]
      ) {
        VStack {
          Text("Discover this area")
            .fontWeight(.semibold)
            .padding(.bottom)
          if case .loading = postVM.state {
            PostCardView.skeleton
          } else {
            PostList(posts: postVM.posts, selectedPost: $selectedPost, showTitle: false)
          }
        }
      } topContent: {
        NavigationButton().onTapGesture {
          withViewportAnimation(.fly) {
            viewport = .followPuck(zoom: GlobalConstants.mapZoom)
          }
        }
      }
      BottomTabView().background(.background)
    }
  }

  var buttons: some View {
    HStack {
      searchIcon
      Spacer()
      CapsuleButton {
        Label(neighborVM.neighborhood, image: "BlueMapIcon")
      }
      Spacer()
      NavigationLink(value: Router.Destination.favorite) {
        CircleButton(systemName: "bookmark.fill")
          .foregroundStyle(LocarieColor.primary)
      }
      .buttonStyle(.plain)
    }
    .fontWeight(.semibold)
    .padding(.horizontal)
    .padding(.bottom, Constants.topButtonsBottomPadding)
  }

  var searchIcon: some View {
    CircleButton(systemName: "magnifyingglass")
      .onTapGesture {
        withAnimation {
          searching.toggle()
        }
      }
  }
}

private enum Constants {
  static let topButtonsBottomPadding: CGFloat = 3
}

#Preview {
  HomePage()
}
