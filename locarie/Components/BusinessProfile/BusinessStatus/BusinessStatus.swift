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
    VStack(alignment: .leading) {
      businessName
      statusRow
    }
  }
}

private extension BusinessStatus {
  var businessName: some View {
    Text(user.businessName)
      .font(.title3)
      .fontWeight(.bold)
  }

  var statusRow: some View {
    HStack(spacing: 0) {
      Text(user.neighborhood)
      Text("·")
      distanceStatus
      Text("·")
      openStatus
    }
    .font(.callout)
    .foregroundStyle(.secondary)
  }

  var distanceStatus: some View {
    Text(formatDistance(distance: distance))
  }

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: user.clLocation)
  }

  @ViewBuilder
  var openStatus: some View {
    if user.isNowClosed {
      Text("Closed")
    } else {
      Text("Open").foregroundStyle(LocarieColors.green)
    }
  }
}
