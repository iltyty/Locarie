//
//  BusinessHomeAvatar.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessHomeAvatar: View {
  let url: String
  var hasUpdates = false

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      AvatarView(
        imageUrl: url,
        size: BusinessAvatarConstants.size
      )
      if hasUpdates {
        updateStatus
      }
    }
  }

  private var updateStatus: some View {
    Circle()
      .fill(LocarieColor.green)
      .frame(width: Constants.iconSize, height: Constants.iconSize)
      .offset(x: Constants.iconOffset, y: Constants.iconOffset)
  }
}

private enum Constants {
  static let iconSize: CGFloat = 12
  static let iconOffset: CGFloat = -3
}

#Preview {
  BusinessHomeAvatar(url: "https://picsum.photos/200", hasUpdates: true)
}
