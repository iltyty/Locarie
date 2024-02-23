//
//  BusinessRowView.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct BusinessRowView: View {
  let user: UserDto

  private let locationManager = LocationManager()

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        avatar
        info
      }
      categories
    }
  }
}

private extension BusinessRowView {
  var avatar: some View {
    AvatarView(
      imageUrl: user.avatarUrl,
      size: Constants.avatarSize
    )
  }

  var info: some View {
    VStack(alignment: .leading) {
      businessName
      statusRow
    }
  }

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

  var categories: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(user.categories, id: \.self) { category in
          TagView(tag: category, isSelected: false)
        }
      }
    }
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 72
}
