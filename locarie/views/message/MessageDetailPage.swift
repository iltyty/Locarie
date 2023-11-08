//
//  MessageDetailPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI

//extension View {
//    func swipeToGoBack() -> some View {
//        self.modifier(SwipeToGoBackModifier())
//    }
//}
//
//struct SwipeToGoBackModifier: ViewModifier {
//    @Environment(\.presentationMode) var presentationMode
//    
//    func body(content: Content) -> some View {
//        content
//            .gesture(
//                DragGesture(minimumDistance: 20, coordinateSpace: .global)
//                    .onChanged { value in
//                        print(value)
//                        guard value.startLocation.x < 20, value.translation.width > 100 else { return }
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
//            )
//    }
//}

struct MessageDetailPage: View {
    @State var message = "Message"
    @State var messages: [Message]
    
    init(messages: [Message]) {
        self.messages = messages
    }
    
    var body: some View {
        VStack {
            NavigationBarView()
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(messages, id: \.self) { m in
                        MessageView(message: m)
                    }
//                    MessageView(isSentBySelf: true, content: "hello, I'm Tony Start from the Avengers", avatar: Image("avatar"))
//                    MessageView(isSentBySelf: true, content: "how's everything going these days?", avatar: Image("avatar"))
//                    MessageView(isSentBySelf: false, content: "hello, I'm Steve Rogers from the Avengers", avatar: Image("avatar"))
//                    MessageView(isSentBySelf: false, content: "hh not bad bro ", avatar: Image("avatar"))
//                    MessageView(isSentBySelf: true, content: "good, go get a shot tonight?", avatar: Image("avatar"))
//                    MessageView(isSentBySelf: false, content: "ok, what time?", avatar: Image("avatar"))
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
fileprivate struct NavigationBarView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    dismiss()
                }
                .foregroundStyle(.primary)
                .padding(.leading)
                .imageScale(.large)
            AvatarView(name: "avatar", size: Constants.avatarSize)
            Text("Jolene Hornsey")
            Spacer()
        }
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
    let messageVM = MessageViewModel()
    return MessageDetailPage(messages: messageVM.messages[User.business2]!)
}
