//
//  MessageDetailPage.swift
//  locarie
//
//  Created by qiuty on 2023/11/6.
//

import SwiftUI
import UIKit

// extension View {
//    func swipeToGoBack() -> some View {
//        self.modifier(SwipeToGoBackModifier())
//    }
// }
//
// struct SwipeToGoBackModifier: ViewModifier {
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
// }

struct MessageDetailPage: View {
    var user: User
    @State var messages: [Message]

    @State var message = "Message"
    @Environment(\.dismiss) var dismiss

    init(user: User, messages: [Message]) {
        _messages = .init(initialValue: messages)
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
                    .fill(.background)
                    .frame(height: Constants.height)
                    .shadow(color: .gray, radius: 2)
            )
            .padding()
        }
//        .navigationTitle(user.username)
//        .toolbarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden()
    }
}

// extension UINavigationController {
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = nil
//    }
// }

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
            AvatarView(imageUrl: user.avatarUrl, size: Constants.avatarSize)
            Text(user.username)
            Spacer()
        }
    }
}

private enum Constants {
    static let height: CGFloat = 50.0
    static let padding: CGFloat = 20.0
    static let iconPadding: CGFloat = 8.0
    static let cornerRadius: CGFloat = 25.0
    static let avatarSize: CGFloat = 42.0
}

#Preview {
    let messageVM = MessageViewModel()
    return MessageDetailPage(user: UserViewModel.getUserById(1)!, messages: messageVM.messages[UserViewModel.getUserById(3)!]!)
}
