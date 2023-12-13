//
//  MessageViewModel.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation

class MessageViewModel: ObservableObject {
    var messages: [User: [Message]] = [:]

    init() {
        messages = loadLocalCachedMessages(receiver: User())
    }

    func loadLocalCachedMessages(receiver _: User) -> [User: [Message]] {
        [
            User.business1: [
                Message(sender: User.user1, receiver: User.business1, content: "Hello, I'm \(User.user1.username)"),
                Message(sender: User.user1, receiver: User.business1, content: "I wanna order a toasted bread"),
                Message(sender: User.user1, receiver: User.business1, content: "Is it possible to have it delivered to my house at 7 p.m. tonight?"),
                Message(sender: User.business1, receiver: User.user1, content: "Hello, no problem. May I ask what flavor you would like?"),
                Message(sender: User.business1, receiver: User.user1, content: """
                We have the following flavors available:
                Plain,
                Whole Wheat,
                Garlic,
                Cheese,
                Pork Floss,
                Chocolate,
                Blueberry,
                Walnut,
                please let me know your preference.
                """),
                Message(sender: User.user1, receiver: User.business1, content: "I would like the blueberry flavor, please"),
                Message(sender: User.business1, receiver: User.user1, content: "ok, anything else?"),
                Message(sender: User.user1, receiver: User.business1, content: "no, this is enough"),
                Message(sender: User.business1, receiver: User.user1, content: """
                Alright, thank you for your order.\
                We will deliver the blueberry toast to your house at 7 p.m. tonight.\
                If you have any further requests, please don't hesitate to let us know.
                """),
            ],
            User.business2: [
                Message(sender: User.user1, receiver: User.business2, content: """
                Hello, I would like to make a reservation for tomorrow morning at 9 a.m. at your café.
                """),
                Message(sender: User.business2, receiver: User.user1, content: """
                Of course, sir. May I have your name, please?
                """),
                Message(sender: User.user1, receiver: User.business2, content: """
                My name is John Smith.
                """),
                Message(sender: User.business2, receiver: User.user1, content: """
                Thank you, Mr. Smith. How many people will be in your party?
                """),
                Message(sender: User.user1, receiver: User.business2, content: """
                It will be just me.
                """),
                Message(sender: User.business2, receiver: User.user1, content: """
                Great. We have availability at 9 a.m. tomorrow. Is there a specific seating area you prefer?
                """),
                Message(sender: User.user1, receiver: User.business2, content: """
                I would like a window seat if possible, please.
                """),
                Message(sender: User.business2, receiver: User.user1, content: """
                Noted. Your reservation for a window seat at 9 a.m. tomorrow is confirmed. Is there anything else I can assist you with?
                """),
                Message(sender: User.business2, receiver: User.user1, content: """
                Yes, I'd also like to order a cappuccino with milk, please.
                """),
                Message(sender: User.business2, receiver: User.user1, content: """
                Certainly, we can add a cappuccino with milk to your order. We will have it ready for you when you arrive tomorrow.\
                Thank you for choosing our café, Mr. Smith. We look forward to seeing you.
                """),
            ],
        ]
    }
}
