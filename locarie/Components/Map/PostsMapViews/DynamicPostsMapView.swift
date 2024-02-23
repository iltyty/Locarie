//
//  DynamicPostsMapView.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct DynamicPostsMapView: View {
  @Binding var selectedPost: PostDto

  let neighborVM: NeighborhoodLookupViewModel?

  @ObservedObject var postVM: PostListNearbyViewModel

  @State private var cameraChanged = true
  @State private var viewport: Viewport = .camera(center: .london, zoom: 12)

  @StateObject private var locationManager = LocationManager()

  var body: some View {
    Map(viewport: $viewport) {
      Puck2D()

      ForEvery(postVM.posts) { post in
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
      onCameraChanged(state)
    }
    .onReceive(locationManager.$location) { location in
      updatePostsIfNeeded(location)
    }
    .onAppear {
      updateNeighborhoodIfNeeded(locationManager.location)
    }
    .ignoresSafeArea()
    .gesture(dragGesture)
    .gesture(magnifyGesture)
  }
}

private extension DynamicPostsMapView {
  func onCameraChanged(_ state: CameraChanged) {
    updateNeighborhoodIfNeeded(state.cameraState.center)
    updatePostsIfNeeded(state.cameraState.center)
  }

  func updateNeighborhoodIfNeeded(_ location: CLLocation?) {
    guard let location else { return }
    updateNeighborhoodIfNeeded(
      CLLocationCoordinate2D(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    )
  }

  func updateNeighborhoodIfNeeded(_ location: CLLocationCoordinate2D) {
    guard let neighborVM else { return }
    if needUpdatingNeighborhood(vm: neighborVM) {
      updateNeighborhood(location, vm: neighborVM)
    }
  }

  func needUpdatingNeighborhood(vm: NeighborhoodLookupViewModel) -> Bool {
    if !cameraChanged {
      return false
    }
    switch vm.state {
    case .loading: return false
    default: return true
    }
  }

  func updateNeighborhood(
    _ center: CLLocationCoordinate2D,
    vm: NeighborhoodLookupViewModel
  ) {
    vm.lookup(forLocation: center)
    cameraChanged = false
  }

  func updatePostsIfNeeded(_ location: CLLocation?) {
    guard let location else { return }
    updatePostsIfNeeded(
      CLLocationCoordinate2D(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    )
  }

  func updatePostsIfNeeded(_ location: CLLocationCoordinate2D) {
    if needUpdatePosts {
      updatePosts(location)
    }
  }

  var needUpdatePosts: Bool {
    if !cameraChanged {
      return false
    }
    switch postVM.state {
    case .loading: return false
    default: return true
    }
  }

  func updatePosts(_ location: CLLocationCoordinate2D) {
    postVM.getNearbyPosts(withLocation: location)
    cameraChanged = false
  }
}

private extension DynamicPostsMapView {
  var dragGesture: some Gesture {
    DragGesture(minimumDistance: 20, coordinateSpace: .global)
      .onEnded { _ in cameraChanged = true }
  }

  var magnifyGesture: some Gesture {
    MagnifyGesture(minimumScaleDelta: 0.1)
      .onEnded { _ in cameraChanged = true }
  }
}
