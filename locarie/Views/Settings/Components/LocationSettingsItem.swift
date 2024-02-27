//
//  LocationSettingsItem.swift
//  locarie
//
//  Created by qiuty on 27/02/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct LocationSettingsItem<U: UserLocation>: View {
  @Binding var location: U
  @Binding var viewport: Viewport

  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 0) {
      mapView
      Rectangle().fill(LocarieColor.lightGray).frame(height: 1)
      textView
    }
    .background(
      RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke(LocarieColor.lightGray)
    )
  }
}

private extension LocationSettingsItem {
  var mapView: some View {
    Map(viewport: $viewport) {
      Puck2D()
      if let coordinate {
        MapViewAnnotation(coordinate: coordinate) {
          BusinessMapAvatar(url: cacheVM.getAvatarUrl())
        }
      }
    }
    .ornamentOptions(.init(
      scaleBar: .init(visibility: .hidden),
      compass: .init(visibility: .hidden)
    ))
    .frame(height: Constants.mapHeight)
    .clipShape(UnevenRoundedRectangle(
      topLeadingRadius: Constants.cornerRadius,
      topTrailingRadius: Constants.cornerRadius
    ))
  }

  var coordinate: CLLocationCoordinate2D? {
    guard let location = location.location else { return nil }
    return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
  }

  var textView: some View {
    NavigationLink {
      BusinessAddressPage(dto: $location)
    } label: {
      HStack {
        Text("Location").fontWeight(.semibold)
        Spacer()
        Text(location.address).foregroundStyle(.secondary)
        Image(systemName: "chevron.right")
      }
      .padding()
    }
    .buttonStyle(.plain)
  }
}

private enum Constants {
  static let height: CGFloat = 160
  static let mapHeight: CGFloat = 112
  static let cornerRadius: CGFloat = 25
}
