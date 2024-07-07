//
//  RoundedAvatarSkeletonView.swift
//  locarie
//
//  Created by qiuty on 06/05/2024.
//

import SwiftUI

struct RoundedAvatarSkeletonView: View {
  var size: CGFloat = Constants.size
  var radius: CGFloat = Constants.cornerRadius

  var body: some View {
    RoundedRectangle(cornerRadius: radius)
      .fill(LocarieColor.greyMedium)
      .frame(size: size)
  }
}

private enum Constants {
  static let size: CGFloat = 72.0
  static let cornerRadius: CGFloat = 18
}

#Preview {
  RoundedAvatarSkeletonView()
}
