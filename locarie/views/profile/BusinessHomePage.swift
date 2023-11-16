//
//  BusinessHomePage.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import SwiftUI

struct BusinessHomePage: View {
    @Environment(\.dismiss) var dismiss
    
    let user: User
    
    init(_ user: User) {
        self.user = user
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                let width = proxy.size.width
                let height = proxy.size.height / 2
                AsyncImageView(url: user.coverUrl, width: width, height: height) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .ignoresSafeArea(edges: .top)
                }
                
                ScrollView {
                    infoView
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        )
                        .padding(.top, proxy.size.height / 5)
                }
                .overlay {
                    VStack {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 32))
                                .onTapGesture {
                                    dismiss()
                                }
                            Spacer()
                            Image(systemName: "ellipsis")
                                .font(.system(size: 32))
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(.white)
                                .frame(width: proxy.size.width, height: 93)
                                .offset(y: 40)
                                .shadow(radius: 2)
                            Label("Map", systemImage: "map")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 236 / 255, green: 100 / 255, blue: 43 / 255))
                                        .frame(width: 120, height: 50)
                                )
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension BusinessHomePage {
    var infoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            infoHeaderView
            buttonView
            Divider()
            Label(user.locationName, systemImage: "location")
                .lineLimit(1)
            Label(formatOpeningTime(from: user.openTime, to: user.closeTime), systemImage: "clock")
                .lineLimit(1)
            Label(user.homepageUrl, systemImage: "link")
                .lineLimit(1)
                .tint(.primary)
            Label(user.phone, systemImage: "phone")
                .lineLimit(1)
            Divider()
            Label("Reviews", systemImage: "message")
        }
    }
}

extension BusinessHomePage {
    var buttonView: some View {
        HStack {
            buttonBuilder(text: "55 mins ago", systemImage: "heart")
            buttonBuilder(text: "Check-in", systemImage: "hand.thumbsup")
            buttonBuilder(text: "688", systemImage: "bookmark")
        }
    }
    
    func buttonBuilder(text: String, systemImage: String) -> some View {
        HStack {
            Image(systemName: systemImage)
            Text(text)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            Capsule().fill(.white)
                .shadow(radius: 2)
        )
    }
}

extension BusinessHomePage {
    var infoHeaderView: some View {
        VStack(alignment: .leading) {
            HStack {
                AvatarView(imageUrl: user.avatarUrl, size: 64)
                Spacer()
                Image(systemName: "message")
                    .font(.system(size: 20))
                    .padding(10)
                    .background(
                        Circle().fill(.white).shadow(radius: 5)
                    )
            }
            
            HStack {
                Text(user.username)
                Spacer()
                Text(user.category)
                    .foregroundStyle(.secondary)
            }
            
            Text(user.introduction)
                .lineLimit(5)
        }
    }
}


#Preview {
    BusinessHomePage(UserViewModel.getUserById(3)!)
}
