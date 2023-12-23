//
//  BusinessAddressPage.swift
//  locarie
//
//  Created by qiuty on 23/12/2023.
//

import CoreLocation
import MapKit
import SwiftUI

struct BusinessAddressPage: View {
  @StateObject var locationManager = LocationManager()

  @State var address = ""

  var body: some View {
    navigationTitle
    map
    bottom
  }

  var navigationTitle: some View {
    navigationTitleBuilder(title: "Business address")
  }

  var map: some View {
    Map(position: .constant(.region(mapRegion))) {}
  }

  var bottom: some View {
    VStack {
      formItemWithTitleBuilder(
        title: "Address name",
        hint: "Address name",
        input: $address,
        isSecure: false
      )
      .padding(.vertical)
      primaryButtonBuilder(text: "Confirm") {
        print("confirm button tapped")
      }
      .padding(.bottom)
    }
    .background(bottomBackground)
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
  var mapRegion: MKCoordinateRegion {
    .init(
      center: mapCenterLocation,
      latitudinalMeters: Constants.latitudinalMeters,
      longitudinalMeters: Constants.longitudinalMeters
    )
  }

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
