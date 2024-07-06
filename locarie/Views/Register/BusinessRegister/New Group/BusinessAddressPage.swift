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

  @State private var inputting = false
  @State private var searching = false
  @State private var needUpdating = true
  @State private var viewport: Viewport = .followPuck(zoom: Constants.mapZoom)
  @State private var currentDetent = Constants.bottomDetent
  @FocusState private var focusing: Bool

  @StateObject private var suggestVM = PlaceSuggestionsViewModel()
  @StateObject private var retrieveVM = PlaceRetrieveViewModel()
  @StateObject private var reverseVM = PlaceReverseViewModel()

  @Environment(\.dismiss) var dismiss

  var body: some View {
    ZStack {
      mapView.ignoresSafeArea()
      Image("Pin")
      contentView
      VStack {
        Spacer()
        confirmButton
      }
    }
    .onAppear {
      suggestVM.place = dto.address
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
      HStack {
        CircleButton("Chevron.Left")
          .onTapGesture {
            if inputting {
              inputting = false
            } else if searching {
              searching = false
            } else {
              dismiss()
            }
          }
        Spacer()
      }
      .padding(.horizontal, 16)
      Spacer()
      BottomSheet(
        detents: [Constants.bottomDetent, .large],
        currentDetent: $currentDetent
      ) { bottomSheetContent.disabled(currentDetent == Constants.bottomDetent) }
    }
    .ignoresSafeArea(edges: [.bottom])
  }

  var bottomSheetContent: some View {
    Group {
      if currentDetent == Constants.bottomDetent || !inputting {
        addressSearchPage
      } else {
        AddressInputPage(address: $dto.address, neighborhood: $dto.neighborhood)
      }
    }
    .padding(.horizontal, 16)
  }

  var addressSearchPage: some View {
    VStack(spacing: 24) {
      Text("Your Business Address").fontWeight(.bold)
      PlaceSearcher(vm: suggestVM, hint: "Type in your address")
        .focused($focusing)
        .onChange(of: dto.address) { address in
          suggestVM.place = address
        }
        .onChange(of: focusing) { focusing in
          if focusing {
            searching = true
          }
        }
        .onChange(of: suggestVM.place) { _ in
          switch suggestVM.state {
          case .chosen: break
          default:
            if focusing {
              searching = true
            }
          }
        }
        .disabled(currentDetent == Constants.bottomDetent)
      if !searching {
        HStack(spacing: 16) {
          Image("Pencil.Grey")
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .frame(width: 40, height: 40)
            .background(Circle().fill(LocarieColor.greyMedium))
          Text("Enter Manually")
            .foregroundStyle(LocarieColor.greyDark)
            .onTapGesture { inputting = true }
          Spacer()
        }
      }
      Spacer()
    }
  }

  var confirmButton: some View {
    Button {
      dismiss()
    } label: {
      if inputting {
        StrokeButtonFormItem(title: "Done")
          .disabled(isDoneButtonDisabled)
          .opacity(isDoneButtonDisabled ? 0.5 : 1)
          .onTapGesture { inputting = false }
      } else {
        StrokeButtonFormItem(title: "Next step")
          .disabled(isNextButtonDisabled)
          .opacity(isNextButtonDisabled ? 0.5 : 1)
      }
    }
    .padding(.horizontal, 16)
  }

  var isNextButtonDisabled: Bool {
    dto.location == nil || dto.address.isEmpty
  }

  var isDoneButtonDisabled: Bool {
    dto.address.isEmpty || dto.neighborhood.isEmpty
  }
}

private extension BusinessAddressPage {
  private func handleSuggestionChoice(state: PlaceSuggestionsViewModel.State) {
    if case let .chosen(dto) = state {
      searching = false
      retrieveVM.retrieve(mapboxId: dto.mapboxId)
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
  static let animationDuration = 1.0
  static let cornerRadius: CGFloat = 24
  static let bottomVPadding: CGFloat = 40

  static let bottomDetentOffset: CGFloat = 300
  static let bottomDetent: BottomSheetDetent = .absoluteBottom(bottomDetentOffset)
}

#Preview {
  BusinessAddressPage(dto: .constant(RegisterRequestDto()))
}
