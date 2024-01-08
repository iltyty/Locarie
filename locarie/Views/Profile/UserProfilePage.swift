//
//  UserProfilePage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct UserProfilePage: View {
  @StateObject private var cacheViewModel = LocalCacheViewModel.shared

  var body: some View {
    if !cacheViewModel.isLoggedIn() {
      loginOrRegister
    } else if cacheViewModel.isRegularUser() {
      regularUserProfile
    } else {
      businessUserProfile
    }
  }
}

private extension UserProfilePage {
  var loginOrRegister: some View {
    VStack {
      LoginOrRegisterPage()
    }
  }

  var regularUserProfile: some View {
    RegularUserProfilePage()
  }

  var businessUserProfile: some View {
    BusinessUserProfilePage()
  }
}

#Preview {
  UserProfilePage()
    .environmentObject(Router.shared)
    .environmentObject(BottomTabViewRouter())
}
