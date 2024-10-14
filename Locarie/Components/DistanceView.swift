//
//  DistanceView.swift
//  Locarie
//
//  Created by qiuty on 12/10/2024.
//

import SwiftUI

struct DistanceView: View {
  let user: UserDto
  @State private var distance = "0 km"
  @ObservedObject private var locationManager = LocationManager()

  var body: some View {
    Text(distance)
      .font(.custom(GlobalConstants.fontName, size: 12))
      .foregroundStyle(LocarieColor.greyDark)
      .padding(.horizontal, 10)
      .padding(.vertical, 5)
      .background {
        Capsule()
          .fill(.white)
          .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0.25, y: 0.25)
      }
      .padding(5)
      .onAppear {
        if LocalCacheViewModel.shared.isCurrentMilesDistanceUnits() {
          distance = "0 mi"
        }
      }
      .onReceive(locationManager.$location) { location in
        if let location {
          distance = "\(user.distance(to: location))"
        }
      }
  }
}
