//
//  HomePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import MapKit
import SwiftUI

struct HomePage: View {
  @EnvironmentObject var postViewModel: PostViewModel

  @State private var mapRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D.CP,
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1)
  )

  @StateObject private var locationManager = LocationManager()

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        contentView
        BottomTabView()
      }
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
      ForEach(postViewModel.posts) { post in
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
    PostCardView(
      post: postViewModel.posts[0],
      coverWidth: proxy.size.width * Constants
        .postCoverWidthProportion
    )
  }
}

extension HomePage {
  private func getNearbyPosts(withLocation location: CLLocation?) {
    guard let location else {
      return
    }
    Task {
      do {
        let response = try await APIServices.listNearbyPosts(
          latitude: location.coordinate.latitude,
          longitude: location.coordinate.longitude,
          distance: GlobalConstants.postsNearbyDistance
        )
        handleListResponse(response)
      } catch {
        handleListError(error)
      }
    }
  }

  private func handleListResponse(_ response: Response) {
    debugPrint(response)
  }

  private func handleListError(_ error: Error) {
    print(error)
  }
}

private typealias Response = ResponseDto<[PostDto]>

private enum Constants {
  static let postCoverWidthProportion = 0.8
  static let mapMarkerColor = Color.mapMarkerOrange
}

#Preview {
  HomePage()
    .environmentObject(BottomTabViewRouter())
    .environmentObject(PostViewModel())
}
