//
//  BusinessUserProfilePage+SkeletonPage.swift
//  locarie
//
//  Created by qiuty on 15/04/2024.
//

import SwiftUI

extension BusinessUserProfilePage {
  static var avatarRowSkeleton: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 10) {
        RoundedAvatarSkeletonView()
        VStack(alignment: .leading, spacing: 10) {
          SkeletonView(84, 14)
          SkeletonView(146, 10)
        }
        Spacer()
      }
    }
  }

  static var categoriesSkeleton: some View {
    HStack(spacing: 5) {
      SkeletonView(68, 10)
      SkeletonView(68, 10)
      Spacer()
    }
  }

  static var bioSkeleton: some View {
    SkeletonView(48, 10)
  }

  static var postsSkeleton: some View {
    VStack(alignment: .leading, spacing: 16) {
      SkeletonView(48, 10)
      PostCardView.skeleton
      PostCardView.skeleton
    }
  }
}

private enum Constants {
  static let imagAspectRatio: CGFloat = 4 / 3
}

#Preview {
  ScrollView {
    VStack(alignment: .leading) {
      BusinessUserProfilePage.avatarRowSkeleton
      BusinessUserProfilePage.categoriesSkeleton
      BusinessUserProfilePage.bioSkeleton
      BusinessUserProfilePage.postsSkeleton
    }
  }
}
