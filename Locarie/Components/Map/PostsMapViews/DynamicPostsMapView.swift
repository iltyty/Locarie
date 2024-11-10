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

  @ObservedObject var postVM: PostListNearbyAllViewModel
  @ObservedObject var userListVM = UserListViewModel()
  
  var shouldFetchPost: Bool
  @State private var i = 0

  @State private var displayAvatar = false
  @State private var map: MapboxMap!
  @State private var initialPostListFetched = false

  @ObservedObject private var network = Network.shared
  @ObservedObject private var locationManager = LocationManager()

  var body: some View {
    MapReader { proxy in
      Map(viewport: $viewport) {
        Puck2D()
        ForEvery(userListVM.businesses) { user in
          MapViewAnnotation(coordinate: user.coordinate) {
            NavigationLink(value: Router.Int64Destination.businessHome(user.id, false)) {
              BusinessMapAvatar(url: user.avatarUrl, newUpdate: user.hasUpdateIn24Hours)
            }
          }
          .allowOverlap(true)
          .allowOverlapWithPuck(true)
        }
      }
      .mapStyle(MapStyle(uri: StyleURI(rawValue: GlobalConstants.mapStyleURI)!))
      .onCameraChanged { camera in
        let zoom = camera.cameraState.zoom
        if (zoom >= 14) != displayAvatar {
          displayAvatar.toggle()
        }
      }
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 222))
      .onMapTapGesture { _ in
        mapTouched.toggle()
      }
      .onAppear {
        map = proxy.map!
      }
    }
    .onReceive(postVM.$state) { state in
      if state.isFinished() { initialPostListFetched = true }
    }
    .onReceive(locationManager.$location) { location in
      guard !initialPostListFetched else { return }
      guard !postVM.state.isLoading() else { return }
      guard let location else { return }
      updatePosts(location)
      updateBusinesses(location)
    }
    .onChange(of: network.connected) { connected in
      guard !initialPostListFetched else { return }
      guard !postVM.state.isLoading() else { return }
      if connected, let location = locationManager.location {
        updatePosts(location)
        updateBusinesses(location)
      }
    }
    .onChange(of: shouldFetchPost) { fetch in
      i += 1
      guard let location = locationManager.location else {
        return
      }
      updatePosts(location)
    }
    .ignoresSafeArea()
    .simultaneousGesture(dragGesture)
    .simultaneousGesture(magnifyGesture)
  }
}

private extension DynamicPostsMapView {
  func updatePosts(_ location: CLLocation) {
    postVM.getNearbyAllPosts(
      with: CLLocationCoordinate2D(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    )
  }

  func updateBusinesses(_: CLLocation) {
    userListVM.listBusinesses()
  }
}

private extension DynamicPostsMapView {
  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { _ in mapTouched.toggle() }
  }

  var magnifyGesture: some Gesture {
    MagnificationGesture(minimumScaleDelta: 0.1)
      .onChanged { _ in mapTouched.toggle() }
  }
}
