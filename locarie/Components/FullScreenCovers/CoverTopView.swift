//
//  CoverTopView.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//

import SwiftUI

struct CoverTopView: View {
  let user: UserDto
  @Binding var isPresenting: Bool

  var body: some View {
    HStack {
      dismissButton
      avatar
      businessName
      Spacer()
      coverMoreButton
    }
  }

  var dismissButton: some View {
    Image(systemName: "multiply")
      .font(.system(size: Constants.dismissButtonSize))
      .onTapGesture {
        withAnimation(.spring) {
          isPresenting = false
        }
      }
  }

  var avatar: some View {
    AvatarView(imageUrl: user.avatarUrl, size: Constants.avatarSize)
      .padding(.leading, Constants.avatarLeadingPadding)
  }

  var businessName: some View {
    Text(user.businessName).fontWeight(.semibold)
  }

  var coverMoreButton: some View {
    Image(systemName: "ellipsis")
      .font(.system(size: Constants.dismissButtonSize))
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 40
  static let avatarLeadingPadding: CGFloat = 16
  static let dismissButtonSize: CGFloat = 36
}
