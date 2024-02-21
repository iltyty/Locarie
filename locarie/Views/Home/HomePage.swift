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

  @StateObject private var postListVM = PostListNearbyViewModel()
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
      if let location {
        postListVM.getNearbyPosts(withLocation: location)
      }
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

      ForEvery(postListVM.posts) { post in
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
    if postListVM.posts.isEmpty {
      Text("No post in this area.")
        .foregroundStyle(.secondary)
    } else {
      ForEach(postListVM.posts) { post in
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

private enum Constants {
  static let mapMarkerColor = Color.locariePrimary
  static let postCoverWidthProportion = 0.95
  static let bottomSheetCornerRadius = 10.0
}

#Preview {
  HomePage(screenSize: CGSize(width: 393, height: 759))
}
