//
//  UserViewModel.swift
//  locarie
//
//  Created by qiuty on 2023/11/10.
//

import Foundation

class UserViewModel: ObservableObject {
    let uid: Int  // current user's id
    
    var currentUser: User {
        UserViewModel.getUserById(self.uid)
    }
    
    init(uid: Int) {
        self.uid = uid
    }
    
    // TODO: fetch the de-facto result from the backend
    static func getUserById(_ id: Int) -> User {
        switch id {
        case 1:
            User(id: 1, username: "Tony Stark", avatarName: "avatar2")
        case 2:
            User(id: 2, username: "Jolene Hornsey", avatarName: "avatar")
        default:
            User(id: 3, username: "Shreeji", avatarName: "avatar1")
        }
    }
}
