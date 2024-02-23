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
  @Environment(\.dismiss) var dismiss

  @StateObject private var retrieveViewModel = PlaceRetrieveViewModel()
  @StateObject private var suggestionViewModel = PlaceSuggestionsViewModel()

  @Binding var dto: U

  @State private var viewport: Viewport = .followPuck(zoom: Constants.mapZoom)

  private var locationCoordinate: CLLocationCoordinate2D? {
    guard let location = dto.location else {
      return nil
    }
    return CLLocationCoordinate2D(
      latitude: location.latitude,
      longitude: location.longitude
    )
  }

  var body: some View {
    VStack {
      navigationBar
      VStack {
        middle
        bottom
      }
      .padding(.top)
    }
    .onReceive(suggestionViewModel.$state) { state in
      handleSuggestionChoice(state: state)
    }
    .onReceive(retrieveViewModel.$state) { state in
      handleRetrieveResult(state: state)
    }
    .onAppear {
      guard let coordinate = locationCoordinate else {
        return
      }
      viewport = .camera(center: coordinate, zoom: Constants.mapZoom)
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
      guard let result = placeRetrieveDto,
            result.geometry.coordinates.count == 2
      else {
        return
      }
      dto.address = result.properties.name
      dto.neighborhood = result.properties.context.neighborhood.name
      print(dto.neighborhood)
      dto.location = BusinessLocation(
        latitude: result.geometry.coordinates[1],
        longitude: result.geometry.coordinates[0]
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
  var middle: some View {
    ZStack(alignment: .top) {
      map
      placeSearcher
    }
  }

  var bottom: some View {
    confirmButton
  }

  var navigationBar: some View {
    NavigationBar("Business address")
  }

  var map: some View {
    Map(viewport: $viewport) {
      Puck2D(bearing: .heading)
        .showsAccuracyRing(true)

      if let coordinate = locationCoordinate {
        MapViewAnnotation(coordinate: coordinate) {
          Label(dto.address, systemImage: "mappin")
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
    Button {
      dismiss()
    } label: {
      StrokeButtonFormItem(title: "Select")
    }
    .disabled(isButtonDisabled)
    .opacity(buttonOpacity)
    .padding(.bottom)
  }

  var isButtonDisabled: Bool {
    dto.location == nil
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
