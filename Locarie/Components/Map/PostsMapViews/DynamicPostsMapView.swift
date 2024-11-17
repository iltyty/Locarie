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
  var shouldFetchUser: Bool

  @State private var displayAvatar = false
  @State private var map: MapboxMap!
  @State private var initialPostListFetched = false
  @State private var initialUserListFetched = false
  @State private var allBusinessesOnMapFetched = false

  @ObservedObject private var network = Network.shared
  @ObservedObject private var locationManager = LocationManager()

  var body: some View {
    MapReader { proxy in
      Map(viewport: $viewport) {
        Puck2D()
        ForEvery(userListVM.allBusinesses) { user in
          MapViewAnnotation(coordinate: .init(latitude: user.location.latitude, longitude: user.location.longitude)) {
            NavigationLink(
              value: Router.BusinessHomeDestination.businessHome(user.id, user.location.latitude, user.location.longitude, false)
            ) {
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
    .onReceive(userListVM.$state) { state in
      if state.isFinished() { initialUserListFetched = true }
    }
    .onReceive(locationManager.$location) { location in
      guard let location else { return }
      if !initialPostListFetched {
        updatePosts(location)
      }
      if !initialUserListFetched {
        updateBusinesses(location)
      }
    }
    .onChange(of: network.connected) { connected in
      if connected, let location = locationManager.location {
        if !initialPostListFetched {
          updatePosts(location)
        }
        if !initialUserListFetched {
          updateBusinesses(location)
        }
      }
    }
    .onChange(of: shouldFetchPost) { _ in
      guard let location = locationManager.location else {
        return
      }
      updatePosts(location)
    }
    .onChange(of: shouldFetchUser) { _ in
      guard let location = locationManager.location else {
        return
      }
      updateBusinesses(location)
    }
    .ignoresSafeArea()
    .simultaneousGesture(dragGesture)
    .simultaneousGesture(magnifyGesture)
  }
}

private extension DynamicPostsMapView {
  func updatePosts(_ location: CLLocation) {
    guard !postVM.state.isLoading() else { return }
    postVM.getNearbyAllPosts(with: location.coordinate)
  }

  func updateBusinesses(_ location: CLLocation) {
    guard !userListVM.state.isLoading() else { return }
    if userListVM.allBusinesses.isEmpty {
      userListVM.listAllBusinesses()
    }
    userListVM.listBusinesses(with: location.coordinate)
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
