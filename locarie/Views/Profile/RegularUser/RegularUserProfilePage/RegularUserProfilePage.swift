//
//  RegularUserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct RegularUserProfilePage: View {
  @ObservedObject var cacheVM = LocalCacheViewModel.shared

  @State var screenHeight: CGFloat = 0

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Color.black.opacity(0.05).ignoresSafeArea(edges: .all)
        VStack {
          content
          BottomTabView()
        }
      }
      .onAppear {
        screenHeight = proxy.size.height
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }

  var content: some View {
    VStack {
      settingsButton
      Spacer()
      avatarRow
      Spacer()
      BottomSheet(detents: [.medium]) {
        FollowAndLikeView()
      }
    }
  }
}

extension RegularUserProfilePage {
  var settingsButton: some View {
    HStack {
      Spacer()
      NavigationLink(value: Router.Destination.settings) {
        Image(systemName: "gearshape")
          .font(.system(size: Constants.settingsButtonSize))
          .frame(width: Constants.settingsButtonBgSize, height: Constants.settingsButtonBgSize)
          .background {
            Circle()
              .fill(.background)
              .shadow(radius: Constants.settingsButtonShadowRadius)
          }
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal)
  }

  var avatarRow: some View {
    HStack {
      avatar
      username
      Spacer()
      ProfileEditButton()
    }
    .padding(.horizontal)
    .padding(.top, screenHeight * Constants.avatarRowTopPaddingFraction)
  }

  var avatar: some View {
    AvatarView(
      imageUrl: cacheVM.getAvatarUrl(),
      size: Constants.avatarSize
    )
  }

  var username: some View {
    Text(cacheVM.getUsername())
      .font(.title3)
      .fontWeight(.semibold)
  }
}

private enum Constants {
  static let vSpacing: CGFloat = 25
  static let avatarSize: CGFloat = 72
  static let avatarRowTopPaddingFraction: CGFloat = 0.1

  static let settingsButtonSize: CGFloat = 18
  static let settingsButtonBgSize: CGFloat = 40
  static let settingsButtonShadowRadius: CGFloat = 1

  static let editButtonHeight: CGFloat = 40
  static let editButtonShadowRadius: CGFloat = 1
}

#Preview {
  RegularUserProfilePage()
    .environmentObject(Router.shared)
}
