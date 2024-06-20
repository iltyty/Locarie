//
//  BusinessUserProfilePage+SkeletonPage.swift
//  locarie
//
//  Created by qiuty on 15/04/2024.
//

import SwiftUI

extension BusinessUserProfilePage {
  static var skeleton: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 10) {
        RoundedAvatarSkeletonView()
        VStack(alignment: .leading, spacing: 10) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      HStack(spacing: 5) {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
        Spacer()
      }
      SkeletonView(48, 10)
      PostCardView.skeleton
      Spacer()
    }
  }
}

private enum Constants {
  static let imagAspectRatio: CGFloat = 4 / 3
}

#Preview {
  BusinessUserProfilePage.skeleton
}
