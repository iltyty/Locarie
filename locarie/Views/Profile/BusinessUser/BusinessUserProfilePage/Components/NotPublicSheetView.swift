//
//  NotPublicSheetView.swift
//  locarie
//
//  Created by qiuty on 24/06/2024.
//

import SwiftUI

struct NotPublicSheetView: View {
  let user: UserDto

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      handler.padding(.bottom, 2)
      HStack {
        Text("Not Public Yet")
          .font(.custom(GlobalConstants.fontName, size: 20))
        Spacer()
        Text("\(completeCnt) / 8")
          .font(.custom(GlobalConstants.fontName, size: 20))
          .foregroundStyle(LocarieColor.primary)
      }
      Text("Complete your profile to start connecting with customers!")
        .foregroundStyle(LocarieColor.greyDark)
      profileCompleteEntry(!user.profileImageUrls.isEmpty, text: "Business images")
      profileCompleteEntry(!user.avatarUrl.isEmpty, text: "Profile image")
      profileCompleteEntry(!user.businessName.isEmpty, text: "Business name")
      profileCompleteEntry(!user.username.isEmpty, text: "Username")
      profileCompleteEntry(!user.categories.isEmpty, text: "Category")
      profileCompleteEntry(!user.introduction.isEmpty, text: "Bio")
      profileCompleteEntry(user.location != nil, text: "Location")
      profileCompleteEntry(!user.businessHours.isEmpty, text: "Opening hours")
      Spacer()
    }
    .padding(.top, 8)
    .padding(.horizontal, 32)
  }

  private var completeCnt: Int {
    (user.profileImageUrls.isEmpty ? 0 : 1) +
      (user.avatarUrl.isEmpty ? 0 : 1) +
      (user.businessName.isEmpty ? 0 : 1) +
      (user.username.isEmpty ? 0 : 1) +
      (user.categories.isEmpty ? 0 : 1) +
      (user.introduction.isEmpty ? 0 : 1) +
      (user.location == nil ? 0 : 1) +
      (user.businessHours.isEmpty ? 0 : 1)
  }

  private var handler: some View {
    HStack {
      Spacer()
      Capsule()
        .fill(Color(hex: 0xF0F0F0))
        .frame(width: 48, height: 6)
      Spacer()
    }
  }

  @ViewBuilder
  private func profileCompleteEntry(_ complete: Bool, text: String) -> some View {
    HStack(spacing: 10) {
      Group {
        if complete {
          Circle().fill(LocarieColor.primary)
        } else {
          Circle().strokeBorder(LocarieColor.primary, style: .init(lineWidth: 1.8))
        }
      }
      .frame(width: 18, height: 18)
      Text(text)
    }
  }
}

#Preview {
  NotPublicSheetView(user: UserDto())
}
