//
//  BusinessHomeView.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import SwiftUI

struct BusinessHomeView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Image("BusinessHome")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height / 2)
                    .ignoresSafeArea(edges: .top)
                
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

extension BusinessHomeView {
    var infoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            infoHeaderView
            buttonView
            Divider()
            Label("324 Hornsey Rd, Finsbury Park, London, British", systemImage: "location")
                .lineLimit(1)
            Label("8am - 11pm", systemImage: "clock")
                .lineLimit(1)
            Label("https://www.bigjobakery.com", systemImage: "link")
                .lineLimit(1)
                .tint(.primary)
            Label("02039156760", systemImage: "phone")
                .lineLimit(1)
            Divider()
            Label("Reviews", systemImage: "message")
            ForEach(0..<10, id: \.self) { _ in
                Text("This is a review")
            }
        }
    }
}

extension BusinessHomeView {
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

extension BusinessHomeView {
    var infoHeaderView: some View {
        VStack(alignment: .leading) {
            HStack {
                AvatarView(name: "avatar", size: 64)
                Spacer()
                Image(systemName: "message")
                    .font(.system(size: 20))
                    .padding(10)
                    .background(
                        Circle().fill(.white).shadow(radius: 5)
                    )
            }
            
            HStack {
                Text("Jolene Hornsey")
                Spacer()
                Text("Restaurant")
                    .foregroundStyle(.secondary)
            }
            
            Text("Farm-to-table dishes & baked goods are showcased at this down-to-earth, bohemian restaurant.")
                .lineLimit(5)
        }
    }
}


#Preview {
    BusinessHomeView()
}
