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
      sheetButtonBuilder("Edit profile") {
        isPresenting = false
        Router.shared.navigate(to: Router.Destination.userProfileEdit)
      }
      .foregroundStyle(LocarieColor.blue)
      sheetButtonBuilder("Do it later") {
        isPresenting = false
      }
    }
    .padding(.horizontal, 16)
    .onDisappear {
      cacheVM.setFirstLoggedIn(false)
    }
  }

  private func sheetButtonBuilder(_ title: String, action: @escaping () -> Void) -> some View {
    Text(title)
      .fontWeight(.bold)
      .frame(height: 48)
      .frame(maxWidth: .infinity)
      .background {
        RoundedRectangle(cornerRadius: 30).fill(.white).frame(maxWidth: .infinity)
      }
      .onTapGesture {
        action()
      }
  }
}

#Preview {
  ZStack {
    Color.pink
    ProfileEditDialog(isPresenting: .constant(true))
  }
}
