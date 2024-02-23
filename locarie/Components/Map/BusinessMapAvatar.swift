//
//  BusinessMapAvatar.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessMapAvatar: View {
  let url: String
  var amplified = false

  var body: some View {
    VStack {
      avatarView
      triangle
    }
  }

  private var avatarView: some View {
    Circle()
      .fill(.white)
      .frame(width: size, height: size)
      .overlay(avatar)
      .zIndex(1)
  }

  private var size: CGFloat {
    amplified ? Constants.amplifiedSize : Constants.regularSize
  }

  private var avatar: some View {
    AsyncImage(url: URL(string: url)) { image in
      image
        .resizable()
        .scaledToFill()
        .clipShape(Circle())
        .frame(width: avatarSize, height: avatarSize)
    } placeholder: {
      Circle()
        .fill(LocarieColors.mapAvatarBg)
        .frame(width: avatarSize, height: avatarSize)
    }
  }

  private var avatarSize: CGFloat {
    size - Constants.avatarDeltaSize
  }

  private var triangle: some View {
    Image(systemName: "arrowtriangle.down.fill")
      .foregroundStyle(.white)
      .offset(y: triangleOffset)
  }

  private var triangleOffset: CGFloat {
    amplified ? Constants.amplifiedOffset : Constants.regularOffset
  }
}

private enum Constants {
  static let regularSize: CGFloat = 40
  static let amplifiedSize: CGFloat = 50
  static let avatarDeltaSize: CGFloat = 4
  static let regularOffset: CGFloat = -8
  static let amplifiedOffset: CGFloat = -5
}

#Preview {
  ZStack {
    Color.pink
    BusinessMapAvatar(url: "https://picsum.photos/100")
  }
}
