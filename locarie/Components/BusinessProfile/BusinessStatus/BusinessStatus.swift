//
//  BusinessStatus.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessStatus: View {
  let user: UserDto

  @ObservedObject private var locationManager = LocationManager()

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      businessName
      statusRow
    }
  }
}

private extension BusinessStatus {
  var businessName: some View {
    Text(user.businessName)
      .font(.custom(GlobalConstants.fontName, size: 20))
      .fontWeight(.bold)
  }

  var statusRow: some View {
    HStack(spacing: 5) {
      Text(user.neighborhood).foregroundStyle(LocarieColor.greyDark)
      DotView()
      Text(user.distance(to: locationManager.location)).foregroundStyle(LocarieColor.greyDark)
      DotView()
      openStatus
    }
    .font(.custom(GlobalConstants.fontName, size: 14))
  }

  @ViewBuilder
  var openStatus: some View {
    if user.isNowClosed {
      Text("Closed").foregroundStyle(LocarieColor.greyDark)
    } else {
      Text("Open").foregroundStyle(LocarieColor.green)
    }
  }
}
