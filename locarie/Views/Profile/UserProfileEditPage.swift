//
//  UserProfileEditPage.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct UserProfileEditPage: View {
  @ObservedObject private var cacheViewModel = LocalCacheViewModel.shared

  var body: some View {
    if !cacheViewModel.isBusinessUser() {
      BusinessProfileEditPage()
    } else {
      RegularUserProfileEditPage()
    }
  }
}

#Preview {
  UserProfileEditPage()
}
