//
//  PostDetailView.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Image("post")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .ignoresSafeArea(edges: .top)
                
                ScrollView {
                    contentView
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        )
                        .padding(.top, proxy.size.height * 2 / 3)
                }.overlay(alignment: .top) {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 32))
                            .onTapGesture {
                                dismiss()
                            }
                        NavigationLink {
                            BusinessHomeView()
                        } label: {
                            Image("avatar")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }
                        Text("Jolene Hornsey")
                            .fixedSize(horizontal: true, vertical: false)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.system(size: 32))
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension PostDetailView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
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
            Label("Reviews", systemImage: "message")
            ForEach(0..<20) { i in
                Text("This is a review from custosmer \(i)")
            }
            PostCard()
        }
    }
}

#Preview {
    PostDetailView()
}
