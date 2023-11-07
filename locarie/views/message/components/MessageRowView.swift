//
//  MessageRow.swift
//  locarie
//
//  Created by qiuty on 2023/11/1.
//

import SwiftUI

struct MessageRowView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("avatar")
                .resizable()
                .clipShape(Circle())
                .frame(width: Constants.avatarSize, height: Constants.avatarSize)
            
            VStack(alignment: .leading) {
                Text("Tony Stark")
                Text("Hello, I'm Iron Man!")
            }
            
            Spacer()
            
            VStack {
                Text("Status")
                    .foregroundStyle(.secondary)
                Image(systemName: "9.circle.fill")
            }
        }
    }
    
    struct Constants {
        static let avatarSize: CGFloat = 50
    }
}

#Preview {
    MessageRowView()
}
