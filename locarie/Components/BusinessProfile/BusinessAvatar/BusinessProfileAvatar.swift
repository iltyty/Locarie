//
//  BusinessProfileAvatar.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessProfileAvatar: View {
  let url: String

  @Binding var isPresentingCover: Bool

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      AsyncImage(url: URL(string: url)) { image in
        image.resizable()
          .scaledToFill()
          .frame(width: Constants.size, height: Constants.size)
          .clipShape(Circle())
      } placeholder: {
        SkeletonView(Constants.size, Constants.size, true)
      }
    }
  }

  private var editButton: some View {
    ZStack {
      buttonBackground
      buttonIcon
    }
    .onTapGesture {
      withAnimation(.spring) {
        isPresentingCover = true
      }
    }
  }

  private var buttonBackground: some View {
    Circle()
      .fill(.background)
      .shadow(radius: Constants.buttonShadowRadius)
      .frame(
        width: Constants.buttonBackgroundSize,
        height: Constants.buttonBackgroundSize
      )
  }

  private var buttonIcon: some View {
    Image("BlueEditIcon")
      .resizable()
      .scaledToFill()
      .frame(
        width: Constants.buttonIconSize,
        height: Constants.buttonIconSize
      )
  }
}

private enum Constants {
  static let size: CGFloat = 72.0
  static let buttonIconSize: CGFloat = 12
  static let buttonBackgroundSize: CGFloat = 24
  static let buttonShadowRadius: CGFloat = 1
}
