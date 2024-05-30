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
  }

  private var user: UserDto {
    vm.dto
  }

  private var content: some View {
    HStack(spacing: 10) {
      avatar
      Text(user.businessName)
        .fontWeight(.bold)
      HStack(spacing: 5) {
        Text(user.lastUpdateTime).foregroundStyle(user.hasUpdateIn24Hours ? LocarieColor.green : LocarieColor.greyDark)
        DotView()
        Text(user.neighborhood).foregroundStyle(LocarieColor.greyDark)
        Spacer()
      }
    }
    .font(.custom(GlobalConstants.fontName, size: 14))
  }

  private var skeleton: some View {
    HStack {
      SkeletonView(24, 24, true)
      SkeletonView(60, 10)
      SkeletonView(146, 10)
      Spacer()
    }
  }

  private var avatar: some View {
    AvatarView(imageUrl: user.avatarUrl, size: 24)
  }

  private var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: user.clLocation)
  }
}
