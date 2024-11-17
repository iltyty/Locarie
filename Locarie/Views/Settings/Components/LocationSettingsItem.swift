//
//  LocationSettingsItem.swift
//  locarie
//
//  Created by qiuty on 27/02/2024.
//

@_spi(Experimental) import MapboxMaps
import SwiftUI

struct LocationSettingsItem: View {
  @ObservedObject var profileUpdateVM: ProfileUpdateViewModel
  @Binding var viewport: Viewport

  private let cacheVM = LocalCacheViewModel.shared

  var body: some View {
    NavigationLink {
      BusinessAddressEditPage(profileUpdateVM: profileUpdateVM)
    } label: {
      VStack(spacing: 0) {
        mapView
        LocarieDivider()
        textView
      }
      .background(RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke(LocarieColor.lightGray))
    }
    .buttonStyle(.plain)
  }
}

private extension LocationSettingsItem {
  var mapView: some View {
    Map(viewport: $viewport) {
      Puck2D()
      if let coordinate {
        MapViewAnnotation(coordinate: coordinate) {
          BusinessMapAvatar(url: cacheVM.getAvatarUrl(), newUpdate: false)
        }
      }
    }
    .gestureOptions(disabledAllGesturesOptions())
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
    guard let location = profileUpdateVM.dto.location else { return nil }
    return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
  }

  var textView: some View {
    HStack {
      Text("Location")
      Spacer().contentShape(Rectangle())
      Text(profileUpdateVM.dto.address).foregroundStyle(LocarieColor.greyDark)
      Image("Chevron.Right.Grey")
        .resizable()
        .scaledToFit()
        .frame(size: 16)
    }
    .padding(16)
    .lineLimit(1)
  }
}

private enum Constants {
  static let height: CGFloat = 160
  static let mapHeight: CGFloat = 112
  static let cornerRadius: CGFloat = 25
}
