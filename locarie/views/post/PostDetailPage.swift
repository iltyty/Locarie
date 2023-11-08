//
//  PostDetailPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct PostDetailPage: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                let size = proxy.size
                
                underneathImageView(image: Image("post"), width: size.width, height: size.height)

                ScrollView {
                    contentView(screenWidth: proxy.size.width)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                        .padding(.top, proxy.size.height * Constants.contentTopPaddingProportion)
                }.overlay(alignment: .top) {
                    scrollViewOverlay
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension PostDetailPage {
    func underneathImageView(image: Image, width: CGFloat, height: CGFloat) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .ignoresSafeArea(edges: .top)
    }
}

extension PostDetailPage {
    func contentView(screenWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: Constants.contentVSpacing) {
            HStack {
                Text("30 mins ago")
                    .foregroundStyle(.green)
                Text(" · 800m")
                Spacer()
            }
            Text("Today’s special 🤤🤤🤤")
            Text("potato rosti, mayo & chives 🤤 tap to see today’s lunch")
            Divider()
            Label("324 Hornsey Rd, Finsbury Park, London, British", systemImage: "location")
                .lineLimit(1)
            Label("8am - 11 pm", systemImage: "clock")
            Divider()
            NavigationLink {
                ReviewPage()
            } label: {
                Label("Reviews", systemImage: "message")
                    .tint(.primary)
            }
            PostCardView(coverWidth: screenWidth * 0.7)
        }
    }
}

extension PostDetailPage {
    var scrollViewOverlay: some View {
        HStack {
            Image(systemName: "chevron.backward")
                .font(.system(size: Constants.backButtonSize))
                .onTapGesture {
                    dismiss()
                }
            NavigationLink {
                BusinessHomePage()
            } label: {
                AvatarView(name: "avatar", size: Constants.avatarSize)
            }
            Text("Jolene Hornsey")
                .fixedSize(horizontal: true, vertical: false)
            Spacer()
            Image(systemName: "ellipsis")
                .font(.system(size: Constants.backButtonSize))
        }
        .padding(.horizontal)
    }
}

fileprivate struct Constants {
    static let avatarSize: CGFloat = 36
    static let backButtonSize: CGFloat = 32
    static let contentVSpacing: CGFloat = 20
    static let contentTopPaddingProportion: CGFloat = 2 / 3
}

#Preview {
    PostDetailPage()
}
