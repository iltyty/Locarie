//
//  BusinessUserStatusRow.swift
//  locarie
//
//  Created by qiuty on 16/04/2024.
//

import SwiftUI

struct BusinessUserStatusRow: View {
  @ObservedObject var vm: ProfileGetViewModel

  @StateObject private var locationManager = LocationManager()

  var body: some View {
    Group {
      if case .loading = vm.state {
        skeleton
      } else {
        content
      }
    }
    .lineLimit(1)
  }

  private var user: UserDto {
    vm.dto
  }

  private var content: some View {
    HStack(spacing: Constants.hSpacing) {
      avatar
      Text(user.businessName)
      Text(user.distance(to: locationManager.location)).foregroundStyle(.secondary)
      Text(user.lastUpdateTime).foregroundStyle(LocarieColor.green)
      DotView()
      Text(user.neighborhood)
      Spacer()
    }
  }

  private var skeleton: some View {
    HStack {
      SkeletonView(Constants.avatarSize, Constants.avatarSize, true)
      SkeletonView(60, 10)
      SkeletonView(146, 10)
      Spacer()
    }
  }

  private var avatar: some View {
    AvatarView(imageUrl: user.avatarUrl, size: Constants.avatarSize)
  }

  private var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: user.clLocation)
  }
}

private enum Constants {
  static let hSpacing: CGFloat = 10
  static let avatarSize: CGFloat = 24
}
