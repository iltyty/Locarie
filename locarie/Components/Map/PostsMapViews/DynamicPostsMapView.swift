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
  @State private var bounds: CoordinateBounds?

  @ObservedObject var postVM: PostListWithinViewModel
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    MapReader { proxy in
      Map(viewport: $viewport) {
        Puck2D()

        ForEvery(postVM.posts) { post in
          MapViewAnnotation(coordinate: post.businessLocationCoordinate) {
            NavigationLink {
              BusinessHomePage(uid: post.user.id)
            } label: {
              BusinessMapAvatar(url: post.user.avatarUrl)
            }
          }
        }
      }
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 385))
      .onCameraChanged { state in
        onCameraChanged(state)
      }
      .simultaneousGesture(TapGesture().onEnded { mapTouched.toggle() })
      .onAppear {
        map = proxy.map!
        bounds = map.coordinateBounds(for: .init(cameraState: map.cameraState))
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
  func onCameraChanged(_ state: CameraChanged) {
    if needUpdating {
      DispatchQueue.main.async {
        bounds = map.coordinateBounds(for: .init(cameraState: state.cameraState))
        updatePosts(state.cameraState.center)
      }
    }
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
    let minLatitude = bounds.southeast.latitude
    let maxLatitude = bounds.northwest.latitude
    let minLongitude = bounds.northwest.longitude
    let maxLongitude = bounds.southeast.longitude
    postVM.list(minLatitude, maxLatitude, minLongitude, maxLongitude)
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
