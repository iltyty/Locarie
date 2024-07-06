//
//  UserProfilePage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct UserProfilePage: View {
  @ObservedObject private var cacheViewModel = LocalCacheViewModel.shared

  var body: some View {
    if !cacheViewModel.isLoggedIn() {
      LoginOrRegisterPage()
    } else if cacheViewModel.isBusinessUser() {
      BusinessUserProfilePage()
    } else {
      RegularUserProfilePage()
    }
  }
}

#Preview {
  UserProfilePage()
}
