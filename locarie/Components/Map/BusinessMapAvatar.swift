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
  let newUpdate: Bool
  var amplified = false

  var body: some View {
    ZStack(alignment: .topTrailing) {
      KFImage(URL(string: url))
        .placeholder { SkeletonView(avatarSize, avatarSize, true) }
        .resizable()
        .frame(width: avatarSize, height: avatarSize)
        .clipShape(Circle())
        .frame(width: size, height: size)
        .background {
          Circle()
            .fill(LocarieColor.greyMedium)
            .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0.25, y: 0.25)
        }
      if newUpdate {
        Circle()
          .fill(LocarieColor.green)
          .frame(width: 8, height: 8)
          .frame(width: 12, height: 12)
          .background { Circle().fill(LocarieColor.greyMedium) }
          .offset(x: -offset, y: offset)
      }
    }
  }

  private var offset: CGFloat {
    amplified ? 4 : 1
  }

  private var size: CGFloat {
    amplified ? Constants.amplifiedSize : Constants.regularSize
  }

  private var avatarSize: CGFloat {
    size - 2 * Constants.strokeWidth
  }
}

private enum Constants {
  static let regularSize: CGFloat = 40
  static let amplifiedSize: CGFloat = 60
  static let strokeWidth: CGFloat = 3
}

#Preview {
  ZStack {
    Color.pink
    VStack {
      BusinessMapAvatar(url: "https://picsum.photos/300", newUpdate: false)
      BusinessMapAvatar(url: "https://picsum.photos/300", newUpdate: true)
      BusinessMapAvatar(url: "https://picsum.photos/500", newUpdate: false, amplified: true)
      BusinessMapAvatar(url: "https://picsum.photos/500", newUpdate: true, amplified: true)
    }
  }
}
