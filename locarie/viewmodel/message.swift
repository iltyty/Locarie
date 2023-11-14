//
//  message.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation

struct Message: Hashable {
    let sender: User
    let receiver: User
    let time: Date
    let content: String
    
    init(sender: User, receiver: User, content: String) {
        self.sender = sender
        self.receiver = receiver
        self.time = Date.now
        self.content = content
    }
}
