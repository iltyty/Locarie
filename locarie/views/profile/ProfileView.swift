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
                    UnderView()
                        .padding(.bottom)
                       
                    VStack {
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
                            .padding(.vertical, 10)
                        Divider()
                            .padding(.horizontal)
                        PostCard()
                    }
                    .padding(.top)
                    .background(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 10, topTrailingRadius: 10
                        )
                            .fill(.white)
                            .shadow(radius: 4)
                    )
                }
                .background(Color(hex: 0xf9f9f9))
                
                BottomTabView()
            }
        }
    }
   
}

struct UnderView: View {
    var body: some View {
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
            .padding(.bottom, 80)
            
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
                        .shadow(radius: 0.5)
                )
                .shadow(radius: 10)
        }
    }
    
    struct Constants {
        static let avatarSize: CGFloat = 80
        static let btnEditHeight: CGFloat = 40
        static let btnSettingsSize: CGFloat = 25
    }
}

#Preview {
    ProfileView()
        .environmentObject(BottomTabViewRouter())
}
