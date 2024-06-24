//
//  BusinessMapAvatar.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Kingfisher
import SwiftUI

struct BusinessMapAvatar: View {
  let url: String
  var amplified = false

  var body: some View {
    Circle()
      .fill(.white)
      .frame(width: size, height: size)
      .overlay(avatar)
  }

  private var size: CGFloat {
    amplified ? Constants.amplifiedSize : Constants.regularSize
  }

  private var avatar: some View {
    KFImage(URL(string: url))
      .placeholder {
        Circle()
          .fill(LocarieColor.mapAvatarBg)
          .frame(width: avatarSize, height: avatarSize)
      }
      .resizable()
      .frame(width: avatarSize, height: avatarSize)
      .clipShape(Circle())
  }

  private var avatarSize: CGFloat {
    size - Constants.avatarDeltaSize
  }
}

private enum Constants {
  static let regularSize: CGFloat = 40
  static let amplifiedSize: CGFloat = 60
  static let avatarDeltaSize: CGFloat = 3
}

#Preview {
  ZStack {
    Color.pink
    BusinessMapAvatar(url: "https://picsum.photos/100")
  }
}
