//
//  BusinessAddressPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import CoreLocation
@_spi(Experimental) import MapboxMaps
import SwiftUI

struct BusinessAddressPage: View {
  @StateObject var locationManager = LocationManager()

  @State var viewport: Viewport = .followPuck(zoom: 13)
  @State var address = ""

  var body: some View {
    VStack {
      navigationTitle
      map
      bottom
    }
  }

  var navigationTitle: some View {
    navigationTitleBuilder(title: "Business address")
  }

  var map: some View {
    Map(viewport: $viewport) {
      Puck2D(bearing: .heading)
        .showsAccuracyRing(true)
    }
    .mapStyle(.streets)
  }

  var bottom: some View {
    VStack {
      bottomSearchBar
      confirmButton
    }
    .background(bottomBackground)
  }

  var bottomSearchBar: some View {
    formItemWithTitleBuilder(
      title: "Address name",
      hint: "Address name",
      input: $address,
      isSecure: false
    )
    .padding(.vertical)
  }

  var confirmButton: some View {
    primaryButtonBuilder(text: "Confirm") {
      print("d")
//      PlaceAutocomplete(accessToken: "sk.eyJ1IjoibHVsdS1xIiwiYSI6ImNscWxxaG1vNjJtbHIyam1lcmYyajQza2kifQ.eCqg31YOP24SQ-USbd0VjA")
//        .suggestions(for: address) { result in
//          switch result {
//          case .success(let suggestions):
//            print(suggestions)
//
//          case .failure(let error):
//            debugPrint(error)
//          }
//        }
    }
    .padding(.bottom)
  }

  var bottomBackground: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: Constants.bottomBackgroundCornerRadius,
      topTrailingRadius: Constants.bottomBackgroundCornerRadius
    )
    .fill(.background)
  }
}

extension BusinessAddressPage {
//  var mapRegion: MKCoordinateRegion {
//    .init(
//      center: mapCenterLocation,
//      latitudinalMeters: Constants.latitudinalMeters,
//      longitudinalMeters: Constants.longitudinalMeters
//    )
//  }

  var mapCenterLocation: CLLocationCoordinate2D {
    guard let location = locationManager.location else {
      return .CP
    }
    return CLLocationCoordinate2D(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
  }
}

private enum Constants {
  static let latitudinalMeters: CLLocationDistance = 2000
  static let longitudinalMeters: CLLocationDistance = 2000
  static let bottomBackgroundCornerRadius: CGFloat = 30
}

#Preview {
  BusinessAddressPage()
}
