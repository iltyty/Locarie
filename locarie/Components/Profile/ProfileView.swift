//
//  ProfileView.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileView: View {
  let user: UserDto

  @Binding var isPresentingCover: Bool

  @State private var isPresentingDetail = false

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared
  @ObservedObject private var postsVM = ListUserPostsViewModel()

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      ProfileAvatarRow(
        user,
        isPresentingCover: $isPresentingCover,
        isPresentingDetail: $isPresentingDetail
      )
      ScrollView {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
          ProfileCategories(user)
          ProfileBio(user)
          if isPresentingDetail {
            ProfileDetail(user)
          }
          ProfilePostsCount(postsVM.posts)
          posts
        }
      }
    }
    .onAppear {
      postsVM.getUserPosts(id: cacheVM.getUserId())
    }
  }
}

private extension ProfileView {
  var posts: some View {
    ForEach(postsVM.posts) { post in
      PostCardView(post)
    }
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 16
}
