//
//  ProfileView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    topView.padding(.bottom)
                    bottomView
                }
                .background(Constants.pageBackground)
                BottomTabView()
            }
        }
    }
   
}

extension ProfileView {
    var topView: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(
                        width: Constants.btnSettingsSize,
                        height: Constants.btnSettingsSize
                    )
                    .padding(.trailing)
            }
            AvatarView(name: "avatar", size: Constants.avatarSize)
            Text("Steve Rogers")
            Text("@CaptainAmerica")
                .foregroundStyle(.secondary)
            Text("Edit Profile")
                .padding()
                .background(
                    Capsule()
                        .fill(.white)
                        .frame(height: Constants.btnEditHeight)
                        .shadow(radius: Constants.btnEditShadowRadius)
                )
        }
    }
}

extension ProfileView {
    var bottomView: some View {
        VStack(spacing: Constants.bottomViewVSpacing) {
            HStack {
                Spacer()
                Label("Followed", systemImage: "bookmark")
                Spacer()
                Label("Saved", systemImage: "star")
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            Image(systemName: "map")
            Divider()
                .padding(.horizontal)
            PostCard()
        }
        .padding(.top)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: Constants.bottomViewBackgroundRadius,
                topTrailingRadius: Constants.bottomViewBackgroundRadius
            )
            .fill(.white)
            .shadow(radius: Constants.bottomViewShadowRadius)
        )
    }
}

fileprivate struct Constants {
    static let pageBackground = Color(hex: 0xf9f9f9)
    static let avatarSize: CGFloat = 80
    static let btnSettingsSize: CGFloat = 25
    static let btnEditHeight: CGFloat = 40
    static let btnEditShadowRadius: CGFloat = 2
    static let bottomViewVSpacing: CGFloat = 20
    static let bottomViewShadowRadius: CGFloat = 4
    static let bottomViewBackgroundRadius: CGFloat = 10
}

#Preview {
    ProfileView()
        .environmentObject(BottomTabViewRouter())
}
