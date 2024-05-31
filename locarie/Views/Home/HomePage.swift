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

  @State private var currentDetent: BottomSheetDetent = Constants.mediumDetent
  @State private var mapTouched = false
  @State private var scrollId: Int64? = nil
  @State private var searching = false
  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport =
    .followPuck(zoom: 11)

  @Namespace var namespace

  var body: some View {
    ZStack {
      DynamicPostsMapView(
        viewport: $viewport,
        mapTouched: $mapTouched,
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
    .onChange(of: mapTouched) { _ in
      moveBottomSheet(to: Constants.bottomDetent)
    }
    .onChange(of: currentDetent) { _ in
      scrollId = 0
    }
  }

  private func moveBottomSheet(to detent: BottomSheetDetent) {
    withAnimation(.spring) {
      currentDetent = detent
    }
  }
}

private extension HomePage {
  var contentView: some View {
    VStack(spacing: 0) {
      buttons
      BottomSheet(
        topPosition: .right,
        detents: [Constants.bottomDetent, Constants.mediumDetent, .large],
        currentDetent: $currentDetent
      ) {
        VStack(spacing: 0) {
          Text("Explore")
            .font(.custom(GlobalConstants.fontName, size: 18))
            .fontWeight(.bold)
            .padding(.bottom, 24)
          if case .loading = postVM.state {
            PostCardView.skeleton
          } else {
            PostList(posts: postVM.posts, scrollId: $scrollId, showTitle: false)
          }
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
      BottomTabView()
    }
  }

  var buttons: some View {
    HStack {
      locarieIcon
      Spacer()
      searchIcon
      NavigationLink(value: Router.Destination.favorite) {
        CircleButton(name: "Bookmark.Fill")
      }
      .buttonStyle(.plain)
    }
    .fontWeight(.semibold)
    .padding(.horizontal, 16)
    .padding(.bottom, 8)
  }

  var locarieIcon: some View {
    Image("LocarieIcon")
      .resizable()
      .scaledToFit()
      .frame(width: 40, height: 40)
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .onTapGesture {
        moveBottomSheet(to: .medium)
      }
  }

  var searchIcon: some View {
    CircleButton(name: "MagnifyingGlass")
      .onTapGesture {
        withAnimation {
          searching.toggle()
        }
      }
  }
}

private enum Constants {
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(117)
  static let mediumDetent: BottomSheetDetent = .absoluteBottom(378)
}

#Preview {
  HomePage()
}
