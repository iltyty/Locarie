//
//  MessageDetailView.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

struct MessageDetailView: View {
    @State var message = "Message"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        dismiss()
                    }
                    .foregroundStyle(.primary)
                    .padding(.leading)
                    .imageScale(.large)
                Image("avatar")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: Constants.avatarSize, height: Constants.avatarSize)
                Text("Business Name")
                Spacer()
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    MessageContentView(isSentBySelf: true, content: "hello, I'm Tony Start from the Avengers", avatar: Image("avatar"))
                    MessageContentView(isSentBySelf: true, content: "how's everything going these days?", avatar: Image("avatar"))
                    MessageContentView(isSentBySelf: false, content: "hello, I'm Steve Rogers from the Avengers", avatar: Image("avatar"))
                    MessageContentView(isSentBySelf: false, content: "hh not bad bro ", avatar: Image("avatar"))
                    MessageContentView(isSentBySelf: true, content: "good, go get a shot tonight?", avatar: Image("avatar"))
                    MessageContentView(isSentBySelf: false, content: "ok, what time?", avatar: Image("avatar"))
                }
            }
            
            HStack {
                Image(systemName: "camera")
                    .padding([.leading])
                    .padding([.trailing], Constants.iconPadding)
                
                TextField("Message", text: $message)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                Spacer()
                
                Image(systemName: "location.fill")
                    .foregroundStyle(.blue)
                    .imageScale(.large)
                    .padding(.horizontal)
            }
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(.white)
                    .frame(height: Constants.height)
                    .shadow(color: .gray, radius: 2)
            )
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

fileprivate struct Constants {
    static let height: CGFloat = 50.0
    static let padding: CGFloat = 20.0
    static let iconPadding: CGFloat = 8.0
    static let cornerRadius: CGFloat = 25.0
    static let avatarSize: CGFloat = 42.0
}

#Preview {
    MessageDetailView()
}
