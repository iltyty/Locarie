//
//  BusinessUserProfilePage+SkeletonPage.swift
//  locarie
//
//  Created by qiuty on 15/04/2024.
//

import SwiftUI

extension BusinessUserProfilePage {
  var skeleton: some View {
    VStack(alignment: .leading) {
      HStack {
        SkeletonView(72, 72, true)
        VStack(alignment: .leading) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
      HStack {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
        Spacer()
      }
      SkeletonView(48, 10)
      HStack {
        SkeletonView(24, 24, true)
        SkeletonView(60, 10)
        SkeletonView(146, 10)
        Spacer()
      }
      SkeletonView(screenSize.width * 0.9, screenSize.width * 0.9 / Constants.imagAspectRatio)
      HStack {
        SkeletonView(280, 10)
        SkeletonView(68, 10)
      }
      Spacer()
    }
  }
}

private enum Constants {
  static let imagAspectRatio: CGFloat = 4 / 3
}

#Preview {
  BusinessUserProfilePage().skeleton
}
