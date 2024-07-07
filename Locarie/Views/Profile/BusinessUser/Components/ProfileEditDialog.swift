//
//  ProfileEditDialog.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileEditDialog: View {
  @Binding var isPresenting: Bool

  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 5) {
      bottomDialogButtonBuilder("Edit profile") {
        isPresenting = false
        Router.shared.navigate(to: Router.Destination.userProfileEdit)
      }
      .foregroundStyle(LocarieColor.blue)
      bottomDialogButtonBuilder("Do it later") {
        isPresenting = false
      }
    }
    .padding(.horizontal, 16)
    .onDisappear {
      cacheVM.setFirstLoggedIn(false)
    }
  }
}

#Preview {
  ZStack {
    Color.pink.bottomDialog(isPresented: .constant(true)) {
      ProfileEditDialog(isPresenting: .constant(true))
    }
  }
}
