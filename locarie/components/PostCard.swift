//
//  PostCard.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct PostCard: View {
    var body: some View {
        NavigationLink {
            PostDetailView()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image("cover")
                    .resizable()
                    .scaledToFill()
                    .frame(height: Constants.height)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                    .clipShape(
                        .rect(
                            topLeadingRadius: Constants.borderRadius,
                            topTrailingRadius: Constants.borderRadius
                        )
                    )
                
                Group {
                    HStack {
                        Text("1 min ago")
                            .foregroundStyle(.green)
                        Text("·")
                        Text("3 km")
                            .foregroundStyle(.secondary)
                    }
                    
                    
                    Text("Today's new arrivals.")
                        .font(.title2)
                        .listRowSeparator(.hidden)
                    
                    
                    HStack {
                        Image("avatar")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: Constants.avatarSize, height: Constants.avatarSize)
                        Text("Shreeji")
                        Spacer()
                        Image(systemName: "map")
                    }
                    .padding([.bottom, .trailing], Constants.bottomPadding)
                }
                .padding([.leading])
            }
            .background(RoundedRectangle(cornerRadius: Constants.borderRadius).fill(.white))
            .padding()
            .tint(.primary)
        }
    }
    
    struct Constants {
        static let height: CGFloat = 175
        static let avatarSize: CGFloat = 32
        static let borderRadius: CGFloat = 10.0
        static let bottomPadding: CGFloat = 15.0
    }
}

#Preview {
    PostCard()
}
