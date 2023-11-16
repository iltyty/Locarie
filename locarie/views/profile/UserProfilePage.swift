//
//  UserProfilePage.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct UserProfilePage: View {
    @AppStorage("uid") var uid: Int = 1
    @EnvironmentObject var postViewModel: PostViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init() {}
    
    var user: User {
        UserViewModel.getUserById(uid) ?? User()
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    ScrollView {
                        topView.padding(.bottom)
                        bottomView(screenWidth: proxy.size.width)
                    }
                    .background(Color(uiColor: UIColor.systemBackground))
                    BottomTabView()
                }
            }
        }
    }
}

extension UserProfilePage {
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
            AvatarView(imageUrl: user.avatarUrl, size: Constants.avatarSize)
            Text(user.username)
//            Text("@CaptainAmerica")
//                .foregroundStyle(.secondary)
            Text("Edit Profile")
                .foregroundStyle(.primary)
                .padding()
                .background(
                    Capsule()
                        .fill(colorScheme == .light ? .white : .gray)
                        .frame(height: Constants.btnEditHeight)
                        .shadow(radius: Constants.btnEditShadowRadius)
                )
        }
    }
}

extension UserProfilePage {
    func bottomView(screenWidth: CGFloat) -> some View {
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
            ForEach(postViewModel.favoritePosts) { post in
                PostCardView(post: post, coverWidth: screenWidth * 0.8)
            }
        }
        .padding(.top)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: Constants.bottomViewBackgroundRadius,
                topTrailingRadius: Constants.bottomViewBackgroundRadius
            )
            .fill(.background)
            .shadow(radius: Constants.bottomViewShadowRadius)
        )
    }
}

fileprivate struct Constants {
    static let avatarSize: CGFloat = 80
    static let btnSettingsSize: CGFloat = 25
    static let btnEditHeight: CGFloat = 40
    static let btnEditShadowRadius: CGFloat = 2
    static let bottomViewVSpacing: CGFloat = 20
    static let bottomViewShadowRadius: CGFloat = 4
    static let bottomViewBackgroundRadius: CGFloat = 10
}

#Preview {
    UserProfilePage()
        .environmentObject(BottomTabViewRouter())
        .environmentObject(PostViewModel())
}
