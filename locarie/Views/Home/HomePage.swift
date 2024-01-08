//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import MapKit
import SwiftUI

struct HomePage: View {
  @State var isShowing = true
  @State private var mapRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D.CP,
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1)
  )

  @StateObject private var viewModel = PostListNearbyViewModel()
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    VStack(spacing: 0) {
      contentView
      BottomTabView()
    }
    .onReceive(locationManager.$location) { location in
      getNearbyPosts(withLocation: location)
    }
  }

  var contentView: some View {
    ZStack(alignment: .top) {
      mapView
      upperView
    }
  }

  var mapView: some View {
    Map(position: .constant(.region(mapRegion))) {
      ForEach(viewModel.posts) { post in
        Marker(
          post.businessName,
          coordinate: post.businessLocationCoordinate
        )
        .tint(Constants.mapMarkerColor)
      }
    }
  }

  var upperView: some View {
    GeometryReader { proxy in
      VStack {
        searchBar
        Spacer()
        cardView(proxy: proxy)
      }
    }
  }

  var searchBar: some View {
    NavigationLink {
      SearchPage()
    } label: {
      SearchBarView(
        title: "Explore",
        isDisabled: true
      )
    }
    .buttonStyle(PlainButtonStyle())
  }

  func cardView(proxy: GeometryProxy) -> some View {
    ScrollView {
      ForEach(viewModel.posts) { post in
        PostCardView(
          post: post,
          coverWidth: proxy.size.width * Constants
            .postCoverWidthProportion
        )
      }
    }
  }
}

extension HomePage {
  private func getNearbyPosts(withLocation location: CLLocation?) {
    guard let location else {
      return
    }
    Task {
      await viewModel.getNearbyPosts(
        withLocation: location,
        onError: handleListError
      )
    }
  }

  private func handleListError(_ error: Error) {
    print(error)
  }
}

private typealias Response = ResponseDto<[PostDto]>

private enum Constants {
  static let postCoverWidthProportion = 0.8
  static let mapMarkerColor = Color.locariePrimary
}

#Preview {
  HomePage()
    .environmentObject(BottomTabViewRouter())
}
