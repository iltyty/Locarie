//
//  BusinessHomeAvatar.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct BusinessHomeAvatar: View {
  let url: String

  var body: some View {
    AsyncImage(url: URL(string: url)) { image in
      image.resizable()
        .scaledToFill()
        .frame(width: Constants.size, height: Constants.size)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    } placeholder: {
      RoundedAvatarSkeletonView()
    }
  }
}

private enum Constants {
  static let size: CGFloat = 72
  static let cornerRadius: CGFloat = 18
}
