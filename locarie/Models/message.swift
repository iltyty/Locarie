//
//  message.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation

struct Message: Hashable {
    let id: Int = 1
    let senderId: Int
    let receiverId: Int
    let time: Date = .init()
    let content: String
    
    init(senderId: Int, receiverId: Int, content: String) {
        self.senderId = senderId
        self.receiverId = receiverId
        self.content = content
    }
    
    // uid: the current user's id
    func getTheOtherUser(uid: Int) -> User {
        UserViewModel.getUserById(uid == senderId ? receiverId : senderId)
    }
    
    func getSender() -> User {
        UserViewModel.getUserById(senderId)
    }
    
    func getReceiver() -> User {
        UserViewModel.getUserById(receiverId)
    }
}
