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
  @Binding var selectedPost: PostDto

  var neighborVM: PlaceReverseViewModel? = nil

  @State private var map: MapboxMap!
  @State private var needUpdating = true
  @State private var bounds: CoordinateBounds?

  @ObservedObject var postVM: PostListWithinViewModel
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    MapReader { proxy in
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
      .onAppear {
        map = proxy.map!
      }
    }
    .onReceive(locationManager.$location) { location in
      updatePosts(location)
      updateNeighborhood(location)
    }
    .ignoresSafeArea()
    .gesture(dragGesture)
    .gesture(magnifyGesture)
  }
}

private extension DynamicPostsMapView {
  func onCameraChanged(_ state: CameraChanged) {
    if needUpdating {
      DispatchQueue.main.async {
        bounds = map.coordinateBounds(for: .init(cameraState: state.cameraState))
        updateNeighborhood(state.cameraState.center)
        updatePosts(state.cameraState.center)
      }
    }
  }

  func updateNeighborhood(_ location: CLLocation?) {
    guard let location else { return }
    updateNeighborhood(
      CLLocationCoordinate2D(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    )
  }

  func updateNeighborhood(_ location: CLLocationCoordinate2D) {
    guard let neighborVM else { return }
    neighborVM.lookup(forLocation: location)
    needUpdating = false
  }

  func updatePosts(_ location: CLLocation?) {
    guard let location else { return }
    updatePosts(
      CLLocationCoordinate2D(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    )
  }

  func updatePosts(_: CLLocationCoordinate2D) {
    guard let bounds else { return }
    needUpdating = false
    print(bounds.northwest)
    print(bounds.southeast)
    let minLatitude = bounds.southeast.latitude
    let maxLatitude = bounds.northwest.latitude
    let minLongitude = bounds.northwest.longitude
    let maxLongitude = bounds.southeast.longitude
    postVM.list(minLatitude, maxLatitude, minLongitude, maxLongitude)
  }
}

private extension DynamicPostsMapView {
  var dragGesture: some Gesture {
    DragGesture(minimumDistance: 20, coordinateSpace: .global)
      .onEnded { _ in needUpdating = true }
  }

  var magnifyGesture: some Gesture {
    MagnifyGesture(minimumScaleDelta: 0.1)
      .onEnded { _ in needUpdating = true }
  }
}
