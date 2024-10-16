//
//  ProfileOpenUntil.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileOpenUntil: View {
  let user: UserDto
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label {
      openUntil
    } icon: {
      Image("Clock")
        .resizable()
        .scaledToFit()
        .frame(size: 16)
    }
  }

  @ViewBuilder
  var openUntil: some View {
    if user.businessHours.isEmpty {
      Text(cacheVM.getUserId() == user.id ? "Go edit" : "Opening hours")
        .foregroundStyle(.secondary)
    } else if user.currentOpeningPeriod == 0 {
      Text("Closed").foregroundStyle(.secondary)
    } else {
      HStack(spacing: 0) {
        Text("Open ").foregroundStyle(LocarieColor.green)
        Text(user.openUtil)
      }
    }
  }
}
