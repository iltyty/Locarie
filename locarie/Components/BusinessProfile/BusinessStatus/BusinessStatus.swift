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
    VStack(alignment: .leading, spacing: 10) {
      Text(user.businessName).font(.custom(GlobalConstants.fontName, size: 20))
      HStack(spacing: 5) {
        Text(user.neighborhood).foregroundStyle(LocarieColor.greyDark)
        DotView()
        Text(distance).foregroundStyle(LocarieColor.greyDark)
        DotView()
        if user.isNowClosed {
          Text("Closed").foregroundStyle(LocarieColor.greyDark)
        } else {
          Text("Open").foregroundStyle(LocarieColor.green)
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
