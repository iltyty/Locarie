//
//  user.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation
import SwiftUI

struct User: Hashable, Equatable, Identifiable {
    var id: Int
    var username: String
    var avatarName: String  // TODO: switch to url based avatar
    
    init() {
        id = 1
        username = "Jolene Hornsey"
        avatarName = "avatar"
    }
    
    init(id: Int, username: String, avatarName: String) {
        self.id = id
        self.username = username
        self.avatarName = avatarName
    }
    
    var avatar: Image {
        Image(avatarName)
    }
}

extension User {
    static let business1 = User(id: 1, username: "Jolene Hornsey", avatarName: "avatar")
    static let business2 = User(id: 2, username: "Shreeji", avatarName: "avatar1")
    static let user1 = User(id: 3, username: "Tony Stark", avatarName: "avatar2")
}
