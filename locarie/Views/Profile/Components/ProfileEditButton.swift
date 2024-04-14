//
//  ProfileEditButton.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct ProfileEditButton: View {
  var body: some View {
    NavigationLink(value: Router.Destination.userProfileEdit) {
      HStack {
        Image("EditIcon")
          .resizable()
          .scaledToFit()
          .frame(width: Constants.iconSize, height: Constants.iconSize)
        Text("Edit profile")
      }
      .padding(.horizontal)
      .padding(.vertical, Constants.textHPadding)
      .overlay(overlay)
    }
    .buttonStyle(.plain)
  }

  private var overlay: some View {
    Capsule()
      .fill(.background)
      .shadow(radius: Constants.shadowRadius)
  }
}

private enum Constants {
  static let iconSize: CGFloat = 16
  static let borderColor: Color = .init(hex: 0xD9D9D9)
  static let textHPadding: CGFloat = 10
  static let shadowRadius: CGFloat = 2.0
}

#Preview {
  ProfileEditButton()
}
