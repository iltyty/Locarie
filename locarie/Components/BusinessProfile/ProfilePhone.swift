//
//  ProfilePhone.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfilePhone: View {
  let user: UserDto

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label {
      phoneText
    } icon: {
      Image("Phone")
        .font(.system(size: ProfileConstants.iconSize))
        .frame(size: ProfileConstants.iconSize)
    }
  }

  @ViewBuilder
  var phoneText: some View {
    let text = user.phone
    if #available(iOS 17.0, *) {
      text.isEmpty
        ? Text(cacheVM.getUserId() == user.id ? "Edit" : "Phone").foregroundStyle(LocarieColor.greyDark)
        : Text(text)
    } else {
      text.isEmpty
        ? Text(cacheVM.getUserId() == user.id ? "Edit" : "Phone").foregroundColor(LocarieColor.greyDark)
        : Text(text)
    }
  }
}
