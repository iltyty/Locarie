//
//  BusinessAddressPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import Combine
import CoreLocation
@_spi(Experimental) import MapboxMaps
import SwiftUI

struct BusinessAddressPage<U: UserLocation>: View {
  @Binding var dto: U

  @State private var needUpdating = true
  @State private var viewport: Viewport = .followPuck(zoom: Constants.mapZoom)
  @State private var presentingSheet = false

  @StateObject private var suggestVM = PlaceSuggestionsViewModel()
  @StateObject private var retrieveVM = PlaceRetrieveViewModel()
  @StateObject private var reverseVM = PlaceReverseViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    ZStack {
      mapView.ignoresSafeArea()
      contentView
      Image("Pin")
    }
    .sheet(isPresented: $presentingSheet, content: {
      sheetContent.presentationDetents([.fraction(0.9)])
    })
    .onReceive(suggestVM.$state) { state in
      handleSuggestionChoice(state: state)
    }
    .onReceive(retrieveVM.$state) { state in
      handleRetrieveResult(state: state)
    }
    .onReceive(reverseVM.$address) { address in
      dto.address = address
    }
  }
}

private extension BusinessAddressPage {
  var mapView: some View {
    MapReader { proxy in
      Map(viewport: $viewport) {}
        .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 215))
        .onCameraChanged { state in
          onCameraChanged(state)
        }
        .gesture(dragGesture)
        .gesture(magnifyGesture)
        .onAppear {
          updateNeighborhood(proxy.location?.latestLocation?.coordinate)
        }
    }
  }

  func onCameraChanged(_ state: CameraChanged) {
    if needUpdating {
      updateNeighborhood(state.cameraState.center)
    }
  }

  func updateNeighborhood(_ location: CLLocationCoordinate2D?) {
    guard let location else { return }
    reverseVM.lookup(forLocation: location)
    needUpdating = false
  }

  var dragGesture: some Gesture {
    DragGesture(minimumDistance: 20, coordinateSpace: .global)
      .onEnded { _ in needUpdating = true }
  }

  var magnifyGesture: some Gesture {
    MagnificationGesture(minimumScaleDelta: 0.1)
      .onEnded { _ in needUpdating = true }
  }
}

private extension BusinessAddressPage {
  var contentView: some View {
    VStack {
      topBar
      Spacer()
      VStack(spacing: Constants.bottomVSpacing) {
        searchTitle
        searchBar
        confirmButton
      }
      .padding(.bottom, Constants.bottomVPadding)
      .background(
        UnevenRoundedRectangle(topLeadingRadius: Constants.cornerRadius, topTrailingRadius: Constants.cornerRadius)
          .fill(.background)
      )
    }
    .ignoresSafeArea(edges: [.bottom])
  }

  var searchTitle: some View {
    Text("Your business address").padding(.top)
  }

  var searchBar: some View {
    HStack {
      Image(systemName: "magnifyingglass")
      TextField("Type in your address", text: $dto.address)
        .disabled(true)
    }
    .padding(.horizontal)
    .background(
      Capsule()
        .fill(.background)
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .shadow(radius: 2)
    )
    .padding(.horizontal)
    .onTapGesture {
      presentingSheet = true
    }
  }

  var topBar: some View {
    HStack {
      CircleButton("Chevron.Left").onTapGesture {
        dismiss()
      }
      Spacer()
    }
    .padding(.horizontal, 16)
  }

  var confirmButton: some View {
    Button {
      dismiss()
    } label: {
      StrokeButtonFormItem(title: "Next step")
    }
    .disabled(isButtonDisabled)
    .opacity(buttonOpacity)
    .padding([.horizontal, .bottom])
  }

  var isButtonDisabled: Bool {
    dto.location == nil || dto.address.isEmpty
  }

  var buttonOpacity: CGFloat {
    isButtonDisabled ? Constants.buttonDisabledOpacity : 1
  }
}

private extension BusinessAddressPage {
  var sheetContent: some View {
    VStack {
      searchTitle
      PlaceSearcher(vm: suggestVM)
      Spacer()
    }
  }
}

private extension BusinessAddressPage {
  private func handleSuggestionChoice(state: PlaceSuggestionsViewModel.State) {
    if case let .chosen(dto) = state {
      debugPrint(dto)
      retrieveVM.retrieve(mapboxId: dto.mapboxId)
      presentingSheet = false
    }
  }

  private func handleRetrieveResult(state: PlaceRetrieveViewModel.State) {
    switch state {
    case let .loaded(placeRetrieveDto):
      guard let result = placeRetrieveDto, result.geometry.coordinates.count == 2 else {
        return
      }
      setAddress(result)
      setLocation(result)
      setNeighborhood(result)
      setViewport()
      updateNeighborhood(coordinate)
    default:
      break
    }
  }

  private func setAddress(_ result: PlaceRetrieveDto) {
    dto.address = result.properties.name
  }

  private func setLocation(_ result: PlaceRetrieveDto) {
    dto.location = BusinessLocation(
      latitude: result.geometry.coordinates[1],
      longitude: result.geometry.coordinates[0]
    )
  }

  private func setNeighborhood(_ result: PlaceRetrieveDto) {
    dto.neighborhood = result.properties.context.neighborhood?.name ?? ""
  }

  private func setViewport() {
    withViewportAnimation(.easeIn(duration: Constants.animationDuration)) {
      viewport = .camera(center: coordinate, zoom: Constants.mapZoom)
    }
  }

  private var coordinate: CLLocationCoordinate2D? {
    guard let location = dto.location else { return nil }
    return CLLocationCoordinate2D(
      latitude: location.latitude,
      longitude: location.longitude
    )
  }
}

private enum Constants {
  static let mapZoom = 15.0
  static let buttonDisabledOpacity = 0.5
  static let animationDuration = 1.0
  static let cornerRadius: CGFloat = 24
  static let bottomVSpacing: CGFloat = 36
  static let bottomVPadding: CGFloat = 40
}

#Preview {
  BusinessAddressPage(dto: .constant(RegisterRequestDto()))
}
