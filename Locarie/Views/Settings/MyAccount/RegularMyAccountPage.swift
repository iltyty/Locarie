//
//  RegularMyAccountPage.swift
//  locarie
//
//  Created by qiuty on 30/05/2024.
//

import SwiftUI

struct RegularMyAccountPage: View {
  @State private var presentingAlert = false

  @StateObject private var router = Router.shared
  @StateObject private var deleteVM = UserDeleteViewModel()
  @StateObject private var profileVM = ProfileGetViewModel()
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 24) {
      NavigationBar("My account", divider: true).background(.white)
      VStack(alignment: .leading, spacing: 0) {
        TextSettingsItem(title: "Account Type", value: "Personal Account")
        TextSettingsItem(title: "Email", value: profileVM.dto.email)
        TextSettingsItem(title: "Username", value: profileVM.dto.username)
        TextSettingsItem(title: "First Name", value: profileVM.dto.firstName)
        TextSettingsItem(title: "Last Name", value: profileVM.dto.lastName)
        TextSettingsItem(title: "Version", value: "V1.0.6", divider: false)
        NavigationLink("Edit Profile") { UserProfileEditPage() }
          .padding(.horizontal)
          .padding(.top, 48)
          .foregroundStyle(LocarieColor.blue)
        Button("Delete Account") { presentingAlert = true }
          .padding(.horizontal)
          .padding(.top, 48)
          .foregroundStyle(LocarieColor.red)
        Spacer()
      }
    }
    .background(LocarieColor.greyLight)
    .alert("Confirm", isPresented: $presentingAlert) {
      Button("Delete", role: .destructive) {
        deleteVM.delete(id: cacheVM.getUserId())
      }
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("This will delete all your data")
    }
    .onAppear {
      profileVM.getProfile(userId: cacheVM.getUserId())
    }
    .onReceive(deleteVM.$state) { state in
      if case .finished = state {
        cacheVM.clean()
        router.navigateToRoot()
      }
    }
  }
}

#Preview {
  RegularMyAccountPage()
}
