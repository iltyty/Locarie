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
        VStack {
          LinearGradient(colors: [LocarieColor.primary, Color.white], startPoint: .top, endPoint: .bottom)
            .frame(height: 320)
          Spacer()
        }
        .ignoresSafeArea(edges: .top)
        VStack(spacing: 72) {
          HStack(spacing: 16) {
            Spacer()
            ProfileEditButton()
            settingsButton
          }
          .padding(.trailing, 16)
          avatarRow
          VStack(spacing: 0) {
            FollowAndLikeView()
            BottomTabView()
          }
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
  var settingsButton: some View {
    NavigationLink(value: Router.Destination.settings) {
      Image(systemName: "gearshape")
        .frame(width: 18, height: 18)
        .frame(width: 40, height: 40)
        .background(Circle().fill(.white))
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
