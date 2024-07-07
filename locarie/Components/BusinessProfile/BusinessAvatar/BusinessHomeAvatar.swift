//
//  BusinessHomeAvatar.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import Kingfisher
import SwiftUI

struct BusinessHomeAvatar: View {
  let url: String

  var body: some View {
    KFImage(URL(string: url))
      .placeholder { RoundedAvatarSkeletonView() }
      .resizable()
      .scaledToFill()
      .frame(size: Constants.size)
      .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
      .overlay {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .strokeBorder(LocarieColor.greyMedium, style: .init(lineWidth: 3))
      }
  }
}

private enum Constants {
  static let size: CGFloat = 72
  static let cornerRadius: CGFloat = 18
}
