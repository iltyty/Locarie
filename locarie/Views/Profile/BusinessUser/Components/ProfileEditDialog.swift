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
    ZStack(alignment: .top) {
      dialogBackground
      buttons
    }
    .frame(height: Constants.height)
    .ignoresSafeArea(edges: .all)
    .onDisappear {
      cacheVM.setFirstLoggedIn(false)
    }
  }
}

private extension ProfileEditDialog {
  var dialogBackground: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: Constants.cornerRadius,
      topTrailingRadius: Constants.cornerRadius
    )
    .fill(Constants.bgColor)
  }

  var buttons: some View {
    VStack {
      editButton
      laterButton
    }
    .padding(.top, Constants.buttonsTopPadding)
  }

  var editButton: some View {
    NavigationLink(value: Router.Destination.userProfileEdit) {
      buttonBuilder("Edit profile")
    }
  }

  var laterButton: some View {
    buttonBuilder("Do it later")
      .tint(.primary)
      .onTapGesture {
        withAnimation(.spring) {
          isPresenting = false
        }
      }
  }
}

private extension ProfileEditDialog {
  func buttonBuilder(_ text: String) -> some View {
    ZStack {
      buttonBackground
      Text(text).fontWeight(.semibold)
    }
  }

  var buttonBackground: some View {
    RoundedRectangle(cornerRadius: Constants.cornerRadius)
      .fill(.white)
      .frame(height: Constants.buttonHeight)
      .frame(maxWidth: .infinity)
      .padding(.horizontal)
  }
}

private enum Constants {
  static let height: CGFloat = 180
  static let bgColor: Color = .init(hex: 0xF0F0F0)
  static let bgOpacity: CGFloat = 0.2
  static let cornerRadius: CGFloat = 30
  static let buttonsTopPadding: CGFloat = 25
  static let buttonHeight: CGFloat = 48
}

#Preview {
  ProfileEditDialog(isPresenting: .constant(true))
}
