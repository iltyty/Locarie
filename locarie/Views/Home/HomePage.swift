//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct HomePage: View {
  @State var screenSize: CGSize = .zero

  @StateObject private var postViewModel = PostListNearbyViewModel()
  @StateObject private var locationManager = LocationManager()

  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)
  @State private var topSafeAreaHeight: CGFloat = 0
  @State private var selectedTag: String = ""

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        content
        BottomTabView()
      }
      .onAppear {
        screenSize = proxy.size
        topSafeAreaHeight = proxy.safeAreaInsets.top
      }
      .onChange(of: proxy.size) { _, size in
        screenSize = size
      }
    }
    .onReceive(locationManager.$location) { location in
      getNearbyPosts(withLocation: location)
    }
  }
}

private extension HomePage {
  var content: some View {
    ZStack(alignment: .top) {
      mapView
      contentView
    }
  }

  var mapView: some View {
    Map(viewport: $viewport) {
      Puck2D()

      ForEvery(postViewModel.posts) { post in
        MapViewAnnotation(coordinate: post.businessLocationCoordinate) {
          Image("map").foregroundStyle(Color.locariePrimary)
            .onTapGesture {
              viewport = .camera(
                center: post.businessLocationCoordinate,
                zoom: 12
              )
            }
        }
      }
    }
    .ignoresSafeArea(edges: .all)
  }

  var contentView: some View {
    VStack {
      topContent
      Spacer()
      BottomSheet(detents: [.minimum, .large]) {
        bottomSheetContent
      }
    }
  }

  var topContent: some View {
    HStack {
      CircleButton(systemName: "magnifyingglass")
      Spacer()
      CapsuleButton {
        Label("London", systemImage: "map")
      }
      Spacer()
      CircleButton(systemName: "bookmark")
    }
    .padding([.top, .horizontal])
    .padding(.horizontal)
  }

  var bottomSheetContent: some View {
    VStack {
      bottomSheetTitle
      postList
    }
  }

  var bottomSheetTitle: some View {
    Text("Discover this area")
      .fontWeight(.semibold)
      .padding(.bottom)
  }

  @ViewBuilder
  var postList: some View {
    if postViewModel.posts.isEmpty {
      Text("No post in this area.")
        .foregroundStyle(.secondary)
    } else {
      ForEach(postViewModel.posts) { post in
        PostCardView(
          post: post,
          coverWidth: screenSize.width * Constants.postCoverWidthProportion
        )
      }
      ForEach(postViewModel.posts) { post in
        PostCardView(
          post: post,
          coverWidth: screenSize.width * Constants.postCoverWidthProportion
        )
      }
    }
  }
}

private extension HomePage {
  func getNearbyPosts(withLocation location: CLLocation?) {
    guard let location else {
      return
    }
    Task {
      await postViewModel.getNearbyPosts(
        withLocation: location,
        onError: handleListError
      )
    }
  }

  func handleListError(_ error: Error) {
    print(error)
  }
}

private enum Constants {
  static let mapMarkerColor = Color.locariePrimary
  static let postCoverWidthProportion = 0.95
  static let bottomSheetCornerRadius = 10.0
}

#Preview {
  HomePage(screenSize: CGSize(width: 393, height: 759))
}
