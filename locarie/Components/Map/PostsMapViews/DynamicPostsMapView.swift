//
//  DynamicPostsMapView.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct DynamicPostsMapView: View {
  @Binding var viewport: Viewport
  @Binding var mapTouched: Bool

  @State private var map: MapboxMap!
  @State private var needUpdating = true

  @ObservedObject var postVM: PostListNearbyAllViewModel
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    MapReader { proxy in
      Map(viewport: $viewport) {
        Puck2D()

        ForEvery(postVM.posts) { post in
          MapViewAnnotation(coordinate: post.businessLocationCoordinate) {
            NavigationLink(value: Router.Int64Destination.businessHome(post.user.id)) {
              BusinessMapAvatar(url: post.user.avatarUrl)
            }
          }
        }
      }
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 205))
      .onMapTapGesture { _ in
        mapTouched.toggle()
      }
      .onAppear {
        map = proxy.map!
      }
    }
    .onReceive(locationManager.$location) { location in
      updatePosts(location)
    }
    .ignoresSafeArea()
    .simultaneousGesture(dragGesture)
    .simultaneousGesture(magnifyGesture)
  }
}

private extension DynamicPostsMapView {
  func updatePosts(_ location: CLLocation?) {
    guard let location else { return }
    updatePosts(
      with: CLLocationCoordinate2D(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    )
  }

  func updatePosts(with coordinate: CLLocationCoordinate2D) {
    needUpdating = false
    postVM.getNearbyAllPosts(with: coordinate)
  }
}

private extension DynamicPostsMapView {
  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { _ in mapTouched.toggle() }
      .onEnded { _ in needUpdating = true }
  }

  var magnifyGesture: some Gesture {
    MagnificationGesture(minimumScaleDelta: 0.1)
      .onChanged { _ in mapTouched.toggle() }
      .onEnded { _ in needUpdating = true }
  }
}
