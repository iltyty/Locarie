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

struct BusinessAddressPage: View {
  @Environment(\.dismiss) var dismiss

  @StateObject private var retrieveViewModel = PlaceRetrieveViewModel()
  @StateObject private var suggestionViewModel = PlaceSuggestionsViewModel()

  @Binding var address: String
  @Binding var location: BusinessLocation?

  @State private var viewport: Viewport

  private var locationCoordinate: CLLocationCoordinate2D? {
    guard let location else {
      return nil
    }
    return CLLocationCoordinate2D(
      latitude: location.latitude,
      longitude: location.longitude
    )
  }

  init(address: Binding<String>, location: Binding<BusinessLocation?>) {
    _address = address
    _location = location
    if let location = location.wrappedValue {
      let coordinate = CLLocationCoordinate2D(
        latitude: location.latitude, longitude: location.longitude
      )
      _viewport = .init(wrappedValue: .camera(
        center: coordinate,
        zoom: Constants.mapZoom
      ))
    } else {
      _viewport = .init(wrappedValue: .followPuck(zoom: Constants.mapZoom))
    }
  }

  var body: some View {
    VStack {
      top
      middle
      bottom
    }
    .onReceive(suggestionViewModel.$state) { state in
      handleSuggestionChoice(state: state)
    }
    .onReceive(retrieveViewModel.$state) { state in
      handleRetrieveResult(state: state)
    }
  }

  private func handleSuggestionChoice(state: PlaceSuggestionsViewModel.State) {
    if case let .chosen(dto) = state {
      retrieveViewModel.retrieve(mapboxId: dto.mapboxId)
    }
  }

  private func handleRetrieveResult(state: PlaceRetrieveViewModel.State) {
    switch state {
    case let .loaded(placeRetrieveDto):
      guard let dto = placeRetrieveDto,
            dto.geometry.coordinates.count == 2
      else {
        return
      }
      address = dto.properties.name
      location = BusinessLocation(
        latitude: dto.geometry.coordinates[1],
        longitude: dto.geometry.coordinates[0]
      )
      withViewportAnimation(.easeIn(duration: Constants
          .viewportAnimationDuration))
      {
        viewport = .camera(center: locationCoordinate, zoom: Constants.mapZoom)
      }
    default:
      break
    }
  }
}

private extension BusinessAddressPage {
  var top: some View {
    navigationTitle
  }

  var middle: some View {
    ZStack(alignment: .top) {
      map
      placeSearcher
    }
  }

  var bottom: some View {
    confirmButton
  }

  var navigationTitle: some View {
    navigationTitleBuilder(title: "Business address")
      .padding(.bottom)
      .background(.background)
  }

  var map: some View {
    Map(viewport: $viewport) {
      Puck2D(bearing: .heading)
        .showsAccuracyRing(true)

      if let coordinate = locationCoordinate {
        MapViewAnnotation(coordinate: coordinate) {
          Label(address, systemImage: "mappin")
        }
      }
    }
    .mapStyle(.streets)
  }

  var placeSearcher: some View {
    PlaceSearcher(viewModel: suggestionViewModel)
      .padding(.bottom)
      .background(.background)
  }

  var confirmButton: some View {
    primaryButtonBuilder(text: "Confirm") {
      dismiss()
    }
    .disabled(isButtonDisabled)
    .opacity(buttonOpacity)
    .padding(.bottom)
  }

  var isButtonDisabled: Bool {
    location == nil
  }

  var buttonOpacity: CGFloat {
    isButtonDisabled ? Constants.buttonDisabledOpacity : 1
  }
}

private enum Constants {
  static let mapZoom = 15.0
  static let buttonDisabledOpacity = 0.5
  static let viewportAnimationDuration = 1.0
}

#Preview {
  var address = ""
  var location = BusinessLocation()
  return BusinessAddressPage(
    address: .constant(address),
    location: .constant(location)
  )
}
