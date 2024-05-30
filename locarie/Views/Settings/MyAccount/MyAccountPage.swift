//
//  MyAccountPage.swift
//  locarie
//
//  Created by qiuty on 04/01/2024.
//

import SwiftUI

struct MyAccountPage: View {
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    if cacheVM.isBusinessUser() {
      BusinessMyAccountPage()
    } else {
      RegularMyAccountPage()
    }
  }
}

#Preview {
  MyAccountPage()
}
