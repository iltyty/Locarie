//
//  BusinessStatus.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessStatus: View {
  let user: UserDto

  @State private var distance = ""

  @ObservedObject private var locationManager = LocationManager()

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(user.businessName)
        .font(.custom(GlobalConstants.fontName, size: 20))
        .fontWeight(.bold)
      HStack(spacing: 5) {
        Text(user.neighborhood).foregroundStyle(LocarieColor.greyDark)
        DotView()
        Group {
          if user.currentOpeningPeriod == 0 {
            Text("Closed").foregroundStyle(LocarieColor.greyDark)
          } else {
            Text("Open").foregroundStyle(LocarieColor.green)
          }
        }
      }
      .font(.custom(GlobalConstants.fontName, size: 14))
    }
    .onAppear {
      distance = user.distance(to: locationManager.location)
    }
    .onReceive(locationManager.$location) { location in
      if let location {
        distance = user.distance(to: location)
      }
    }
  }
}
