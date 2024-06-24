//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct RegularUserProfilePage: View {
  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  @Environment(\.dismiss) private var dismiss

  @State private var screenHeight: CGFloat = 0

  @State private var user = UserDto()
  @State private var post = PostDto()
  @State private var isPostCoverPresented = false
  @State private var isProfileCoverPresented = false

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        VStack {
          LinearGradient(colors: [LocarieColor.primary, Color.white], startPoint: .top, endPoint: .bottom)
            .frame(height: 320)
          Spacer()
        }
        .ignoresSafeArea(edges: .top)
        VStack(spacing: 0) {
          ZStack(alignment: .top) {
            ScrollView {
              VStack(spacing: 72) {
                HStack(spacing: 16) {
                  Spacer()
                  ProfileEditButton()
                  settingsButton
                }
                .padding(.horizontal, 16)
                avatarRow
                VStack(spacing: 0) {
                  FollowAndLikeView(
                    post: $post,
                    user: $user,
                    isPostCoverPresented: $isPostCoverPresented,
                    isProfileCoverPresented: $isProfileCoverPresented
                  )
                }
              }
            }
            .scrollIndicators(.hidden)
            if cacheVM.isBusinessUser() {
              HStack {
                backButton
                Spacer()
              }
              .padding(.horizontal, 16)
            }
          }
          BottomTabView()
        }
        if isProfileCoverPresented {
          BusinessProfileCover(
            user: user,
            onAvatarTapped: {
              isProfileCoverPresented = false
              Router.shared.navigate(to: Router.Int64Destination.businessHome(user.id, true))
            },
            isPresenting: $isProfileCoverPresented
          )
        }
        if isPostCoverPresented {
          PostCover(
            post: post,
            tags: user.categories,
            onAvatarTapped: {
              isPostCoverPresented = false
              Router.shared.navigate(to: Router.Int64Destination.businessHome(user.id, true))
            },
            isPresenting: $isPostCoverPresented
          )
        }
      }
      .onAppear {
        screenHeight = proxy.size.height
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }
}

extension RegularUserProfilePage {
  var backButton: some View {
    Image(systemName: "chevron.left")
      .resizable()
      .scaledToFit()
      .frame(width: 18, height: 18)
      .frame(width: 40, height: 40)
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
        .frame(width: 18, height: 18)
        .frame(width: 40, height: 40)
        .background(Circle().fill(.white).shadow(radius: 2))
    }
    .buttonStyle(.plain)
  }

  var avatarRow: some View {
    HStack(spacing: 10) {
      AvatarView(imageUrl: cacheVM.getAvatarUrl(), size: 92, isBusiness: false)
      Text(cacheVM.getUsername())
        .font(.custom(GlobalConstants.fontName, size: 20))
      Spacer()
    }
    .padding(.horizontal, 16)
  }
}

#Preview {
  RegularUserProfilePage()
}
