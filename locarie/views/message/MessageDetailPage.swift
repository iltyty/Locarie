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
    var user: User
    @State var messages: [Message]
    
    @State var message = "Message"
    @Environment(\.dismiss) var dismiss
    
    init(user: User, messages: [Message]) {
        self._messages = .init(initialValue: messages)
        self.user = user
    }
    
    var body: some View {
        VStack {
            navigationBar(dismiss: dismiss, user: user)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(messages, id: \.self) { m in
                        MessageView(message: m)
                    }
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

extension MessageDetailPage {
    func navigationBar(dismiss: DismissAction, user: User) -> some View {
        HStack(spacing: 15) {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    dismiss()
                }
                .foregroundStyle(.primary)
                .padding(.leading)
                .imageScale(.large)
            AvatarView(image: user.avatar, size: Constants.avatarSize)
            Text(user.username)
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
    return MessageDetailPage(user: User.business2, messages: messageVM.messages[User.business2]!)
}
