//
//  BusinessMyAccountPage.swift
//  locarie
//
//  Created by qiuty on 30/05/2024.
//

import SwiftUI

struct BusinessMyAccountPage: View {
  @State private var presentingAlert = false

  @StateObject private var router = Router.shared
  @StateObject private var deleteVM = UserDeleteViewModel()
  @StateObject private var profileVM = ProfileGetViewModel()
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 24) {
      NavigationBar("My account", divider: true).background(.white)
      VStack(alignment: .leading, spacing: 0) {
        TextSettingsItem(title: "Account type", value: "Business")
        TextSettingsItem(title: "Business name", value: profileVM.dto.businessName)
        TextSettingsItem(title: "Business category", value: profileVM.dto.categories.joined(separator: ", "))
        TextSettingsItem(title: "Email", value: profileVM.dto.email)
        TextSettingsItem(title: "Username", value: profileVM.dto.username)
        TextSettingsItem(title: "First name", value: profileVM.dto.firstName)
        TextSettingsItem(title: "Last name", value: profileVM.dto.lastName)
        TextSettingsItem(title: "Version", value: "V0.0.1", divider: false)
        NavigationLink("Edit profile") { UserProfileEditPage() }
          .padding(.horizontal)
          .padding(.top, 48)
          .foregroundStyle(LocarieColor.blue)
        Button("Delete account") { presentingAlert = true }
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
  BusinessMyAccountPage()
}
