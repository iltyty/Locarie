//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct HomePage: View {
  @StateObject private var locationManager = LocationManager()
  @StateObject private var postListVM = PostListNearbyViewModel()
  @StateObject private var neighborVM = NeighborhoodLookupViewModel()

  @State private var cameraChanged = false
  @State private var selectedPost = PostDto()
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)

  var body: some View {
    ZStack {
      mapView
      contentView
    }
    .ignoresSafeArea(edges: .bottom)
    .onAppear {
      updateNeighborhood(.london)
    }
    .onReceive(locationManager.$location) { location in
      if let location {
        postListVM.getNearbyPosts(withLocation: location)
      }
    }
    .onReceive(postListVM.$posts) { posts in
      selectedPost = posts.first ?? PostDto()
    }
  }
}

private extension HomePage {
  var mapView: some View {
    Map(viewport: $viewport) {
      Puck2D()

      ForEvery(postListVM.posts) { post in
        MapViewAnnotation(coordinate: post.businessLocationCoordinate) {
          BusinessMapAvatar(
            url: post.user.avatarUrl,
            amplified: post.id == selectedPost.id
          )
          .onTapGesture {
            selectedPost = post
          }
        }
      }
    }
    .onCameraChanged { state in
      if needUpdatingNeighborhood {
        updateNeighborhood(state.cameraState.center)
      }
    }
    .ignoresSafeArea(edges: .all)
    .gesture(dragGesture)
    .gesture(magnifyGesture)
  }

  var needUpdatingNeighborhood: Bool {
    if !cameraChanged {
      return false
    }
    switch neighborVM.state {
    case .loading: return false
    default: return true
    }
  }

  var dragGesture: some Gesture {
    DragGesture(minimumDistance: 20, coordinateSpace: .global)
      .onEnded { _ in cameraChanged = true }
  }

  var magnifyGesture: some Gesture {
    MagnifyGesture(minimumScaleDelta: 0.1)
      .onEnded { _ in cameraChanged = true }
  }

  func updateNeighborhood(_ center: CLLocationCoordinate2D) {
    neighborVM.lookup(forLocation: center)
    cameraChanged = false
  }

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
  HomePage()
}
