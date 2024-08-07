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
  @State var pageState: PageState = .initial

  @State private var setupDone = false
  @State private var needUpdating = true
  @State private var viewport: Viewport = .followPuck(zoom: Constants.mapZoom)
  @State private var currentDetent = Constants.bottomDetent

  @FocusState private var inputtingPlace: Bool

  @StateObject private var suggestVM = PlaceSuggestionsViewModel()
  @StateObject private var retrieveVM = PlaceRetrieveViewModel()
  @StateObject private var reverseVM = PlaceReverseViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        VStack(spacing: 0) {
          ZStack {
            mapView.frame(height: max(0, mapHeight(proxy: proxy)))
            if !setupDone {
              Image("Pin.Grey")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 61)
                .offset(y: -24)
            }
          }
          .ignoresSafeArea(edges: .top)
          Spacer()
        }
        contentView
        VStack {
          Spacer()
          confirmButton
        }
      }
    }
    .task(id: dto) {
      checkDtoInfo()
      if let location = dto.location {
        viewport = .camera(
          center: .init(
            latitude: location.latitude,
            longitude: location.longitude
          ),
          zoom: Constants.mapZoom
        )
      }
    }
    .onChange(of: currentDetent) { newDetent in
      if newDetent == .large {
        pageState = .editing
        inputtingPlace = true
      } else {
        pageState = setupDone ? .done : .initial
      }
    }
    .onReceive(suggestVM.$state) { state in
      if case let .chosen(dto) = state {
        retrieveVM.retrieve(mapboxId: dto.mapboxId)
      }
    }
    .onReceive(retrieveVM.$state) { handleRetrieveResult(state: $0) }
  }

  private func mapHeight(proxy: GeometryProxy) -> CGFloat {
    proxy.size.height - Constants.bottomDetentOffset + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom + 30
  }

  private func checkDtoInfo() {
    if dto.location != nil, !dto.address.isEmpty, !dto.neighborhood.isEmpty {
      setupDone = true
      pageState = .done
    }
  }
}

private extension BusinessAddressPage {
  var mapView: some View {
    MapReader { _ in
      Map(viewport: $viewport) {
        if setupDone, let location = dto.location {
          MapViewAnnotation(coordinate: .init(latitude: location.latitude, longitude: location.longitude)) {
            Image("Pin")
              .resizable()
              .scaledToFit()
              .frame(width: 32, height: 61)
              .offset(y: -24)
          }
        }
      }
      .ornamentOptions(noScaleBarAndCompassOrnamentOptions(bottom: 40))
      .onCameraChanged { onCameraChanged($0) }
      .gesture(dragGesture)
      .gesture(magnifyGesture)
    }
  }

  func onCameraChanged(_ state: CameraChanged) {
    checkDtoInfo()
    let center = state.cameraState.center
    if !setupDone {
      if dto.location != nil {
        dto.location = .init(latitude: center.latitude, longitude: center.longitude)
      }
      if needUpdating {
        updateNeighborhood(center)
      }
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
      HStack {
        CircleButton("Chevron.Left").onTapGesture {
          switch pageState {
          case .initial:
            dismiss()
          case .editing:
            moveCurrentDetent(to: Constants.bottomDetent)
          case .done:
            moveCurrentDetent(to: .large)
          }
          dismiss()
        }
        Spacer()
      }
      .padding(.horizontal, 16)
      Spacer()
      BottomSheet(
        topPosition: .right,
        detents: [Constants.bottomDetent, .large],
        currentDetent: $currentDetent
      ) {
        bottomSheetContent
          .padding(.horizontal, 16)
          .disabled(currentDetent == Constants.bottomDetent)
      } topContent: {
        editButton
      }
      .offset(y: setupDone && currentDetent == Constants.bottomDetent ? -48 : 0)
    }
    .ignoresSafeArea(edges: [.bottom])
  }

  @ViewBuilder
  var editButton: some View {
    if setupDone {
      HStack(spacing: 10) {
        Image("Pencil.Black")
          .resizable()
          .scaledToFit()
          .frame(size: 16)
        Text("Edit")
      }
      .frame(width: 80, height: 40)
      .background {
        Capsule()
          .fill(.white)
          .universalShadow()
      }
      .onTapGesture {
        pageState = .initial
      }
      .padding(.horizontal, 16)
    } else {
      EmptyView()
    }
  }

  @ViewBuilder
  var bottomSheetContent: some View {
    VStack(spacing: 24) {
      Text("Your Business Address").fontWeight(.bold)
      switch pageState {
      case .initial, .editing:
        VStack(alignment: .leading, spacing: 10) {
          PlaceSearcher(vm: suggestVM, placeholder: "Type in your address", hint: "Postcode will not work.")
            .focused($inputtingPlace)
            .onChange(of: dto.address) { address in
              suggestVM.place = address
            }
            .disabled(currentDetent == Constants.bottomDetent)
        }
      case .done:
        HStack(spacing: 10) {
          Image("Map")
            .resizable()
            .scaledToFit()
            .frame(size: 16)
          Text("\(dto.address), \(dto.neighborhood)").lineLimit(1)
          Spacer()
        }
        .frame(height: 48)
      }
      Spacer()
    }
  }

  var confirmButton: some View {
    Button {
      dismiss()
    } label: {
      switch pageState {
      case .initial:
        StrokeButtonFormItem(
          title: "Next step",
          color: setupDone ? LocarieColor.primary : LocarieColor.greyDark
        )
        .disabled(!setupDone)
      case .editing:
        EmptyView()
      case .done:
        StrokeButtonFormItem(
          title: "Done",
          color: setupDone ? LocarieColor.primary : LocarieColor.greyDark
        )
        .disabled(!setupDone)
      }
    }
    .padding(.horizontal, 16)
  }
}

private extension BusinessAddressPage {
  func handleRetrieveResult(state: PlaceRetrieveViewModel.State) {
    switch state {
    case let .loaded(placeRetrieveDto):
      guard let result = placeRetrieveDto, result.geometry.coordinates.count == 2 else {
        return
      }
      moveCurrentDetent(to: Constants.bottomDetent)
      setAddress(result)
      setLocation(result)
      setNeighborhood(result)
      setViewport()
    default:
      break
    }
  }

  func moveCurrentDetent(to detent: BottomSheetDetent) {
    withAnimation(.spring) {
      currentDetent = detent
    }
  }

  func setAddress(_ result: PlaceRetrieveDto) {
    dto.address = result.properties.name
  }

  func setLocation(_ result: PlaceRetrieveDto) {
    dto.location = BusinessLocation(
      latitude: result.geometry.coordinates[1],
      longitude: result.geometry.coordinates[0]
    )
  }

  func setNeighborhood(_ result: PlaceRetrieveDto) {
    dto.neighborhood = result.properties.context.neighborhood?.name ?? ""
  }

  func setViewport() {
    withViewportAnimation(.easeIn(duration: Constants.animationDuration)) {
      viewport = .camera(center: coordinate, zoom: Constants.mapZoom)
    }
  }

  var coordinate: CLLocationCoordinate2D? {
    guard let location = dto.location else { return nil }
    return CLLocationCoordinate2D(
      latitude: location.latitude,
      longitude: location.longitude
    )
  }
}

extension BusinessAddressPage {
  enum PageState: Equatable { case initial, editing, done }
}

private enum Constants {
  static let mapZoom = 15.0
  static let animationDuration = 1.0
  static let cornerRadius: CGFloat = 24
  static let bottomVPadding: CGFloat = 40

  static let bottomDetentOffset: CGFloat = 250
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(bottomDetentOffset)
}

private struct TestView: View {
  @StateObject var vm = RegisterViewModel(type: .business)

  var body: some View {
    BusinessAddressPage(dto: $vm.dto)
      .onAppear {
        vm.dto.location = .init(
          latitude: CLLocation.london.coordinate.latitude,
          longitude: CLLocation.london.coordinate.longitude
        )
        vm.dto.neighborhood = "Marylebone"
        vm.dto.address = "6 Chiltern Street"
      }
  }
}

#Preview {
  TestView()
}
