//
//  CoverTopView.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//

import SwiftUI

struct CoverTopView: View {
  let user: UserDto
  let sharePreviewText: String

  @Binding var isPresenting: Bool

  var body: some View {
    HStack {
      dismissButton
      avatar
      businessName
      Spacer()
      shareButton
    }
  }

  var dismissButton: some View {
    buttonBuilder(Image(systemName: "multiply"))
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

  @ViewBuilder
  var shareButton: some View {
    let link = URL(string: "https://www.hackingwithswift.com")!
    ShareLink(
      item: link,
      preview: SharePreview(sharePreviewText, image: Image("LocarieIcon"))
    ) {
      buttonBuilder(Image("ShareIcon"))
    }
  }

  var moreButton: some View {
    buttonBuilder(Image(systemName: "ellipsis"))
  }

  func buttonBuilder(_ image: Image) -> some View {
    image
      .resizable()
      .scaledToFit()
      .frame(width: Constants.buttonSize, height: Constants.buttonSize)
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 40
  static let avatarLeadingPadding: CGFloat = 16
  static let buttonSize: CGFloat = 18
}
