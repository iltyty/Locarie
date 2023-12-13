//
//  user.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation
import SwiftUI

typealias UserId = Int

extension UserId {
    init(_ id: Int) {
        self = id
    }
    
    var name: String {
        UserViewModel.getUserById(self).username
    }
}

struct User: Hashable, Equatable, Identifiable {
    enum UserType {
        case plain, business
    }
    enum BusinessType {
        case restaurant, coffee, cinema, bookstore
    }
    
    var id: UserId
    var username: String
    var avatarName: String  // TODO: switch to url based avatar
    var type: UserType = .plain
    
    // properties below are only for business users,
    var coverName: String = "cover"  // TODO: switch to url based cover
    var openTimeStart: Date = Date.init()
    var openTimeEnd: Date = Date.init()
    var businessType: BusinessType = .restaurant
    var introduction: String = ""
    var address: String = ""
    var hostUrl: String = ""
    var phone: String = ""
    

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
