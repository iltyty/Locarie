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
      BusinessHomeAvatar(url: url)
      editButton
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
      .stroke(.secondary)
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
  static let buttonIconSize: CGFloat = 12
  static let buttonBackgroundSize: CGFloat = 24
}
