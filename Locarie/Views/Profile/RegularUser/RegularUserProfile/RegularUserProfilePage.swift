//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import Kingfisher
import SwiftUI

struct RegularUserProfilePage: View {
  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  @Environment(\.dismiss) private var dismiss

  @State private var screenHeight: CGFloat = 0
  @State private var topSafeAreaHeight: CGFloat = 0

  @State private var user = UserDto()
  @State private var post = PostDto()
  @State private var isPostCoverPresented = false
  @State private var isProfileCoverPresented = false

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        ZStack(alignment: .top) {
          ScrollView {
            VStack(spacing: 0) {
              avatarRow
                .padding(.top, topSafeAreaHeight + 72 + 40)
                .padding(.bottom, 72)
                .background {
                  LinearGradient(
                    colors: [LocarieColor.primary, Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                  )
                  .ignoresSafeArea(edges: .top)
                }
              FollowAndLikeView(
                post: $post,
                user: $user,
                isPostCoverPresented: $isPostCoverPresented,
                isProfileCoverPresented: $isProfileCoverPresented
              )
              .background(.white)
            }
          }
          .scrollIndicators(.hidden)
          .background {
            VStack {
              LocarieColor.primary.frame(height: 300)
              Spacer()
            }
          }
          HStack {
            if cacheVM.isBusinessUser() {
              backButton
            }
            Spacer()
            ProfileEditButton()
            settingsButton
          }
          .padding(.horizontal, 16)
          .padding(.top, topSafeAreaHeight)
        }
        BottomTabView()
      }
      .ignoresSafeArea(edges: .top)
      .task(id: proxy.size.height) {
        screenHeight = proxy.size.height
      }
      .task(id: proxy.safeAreaInsets.top) {
        topSafeAreaHeight = proxy.safeAreaInsets.top
      }
      if isPostCoverPresented {
        ImagesFullScreenCover(
          index: 0,
          imageUrls: post.imageUrls,
          isPresenting: $isPostCoverPresented
        )
      }
      if isProfileCoverPresented {
        ImagesFullScreenCover(
          index: 0,
          imageUrls: user.profileImageUrls,
          isPresenting: $isProfileCoverPresented
        )
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }
}

extension RegularUserProfilePage {
  var backButton: some View {
    Image("Chevron.Left")
      .resizable()
      .scaledToFit()
      .frame(size: 18)
      .frame(size: 40)
      .background(Circle().fill(.white).shadow(radius: 2))
      .buttonStyle(.plain)
      .onTapGesture {
        dismiss()
      }
  }

  var settingsButton: some View {
    NavigationLink(value: Router.Destination.settings) {
      Image(systemName: "gearshape")
        .resizable()
        .scaledToFit()
        .frame(size: 18)
        .frame(size: 40)
        .background(Circle().fill(.white).shadow(radius: 2))
    }
    .buttonStyle(.plain)
  }

  var avatarRow: some View {
    HStack(spacing: 10) {
      if cacheVM.getAvatarUrl().isEmpty {
        defaultAvatar(size: 92, isBusiness: cacheVM.isBusinessUser())
      } else {
        KFImage(URL(string: cacheVM.getAvatarUrl()))
          .placeholder {
            SkeletonView(92, 92, true)
          }
          .resizable()
          .scaledToFill()
          .frame(size: 92)
      }
      Text(cacheVM.getUsername())
        .font(.custom(GlobalConstants.fontName, size: 20))
        .fontWeight(.bold)
      Spacer()
    }
    .padding(.horizontal, 16)
  }
}

#Preview {
  RegularUserProfilePage()
}
