//
//  ProfileView.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileView: View {
  let id: Int64
  let user: UserDto

  @Binding var isPresentingCover: Bool

  @State private var isPresentingDetail = false

  @StateObject private var postsVM = ListUserPostsViewModel()

  var body: some View {
    VStack(alignment: .leading, spacing: Constants.vSpacing) {
      BusinessProfileAvatarRow(
        user: user,
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
      postsVM.getUserPosts(id: id)
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
