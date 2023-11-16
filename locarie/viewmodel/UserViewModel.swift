//
//  UserViewModel.swift
//  locarie
//
//  Created by qiuty on 2023/11/11.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @AppStorage("userId") var uid: Int = 0  // current user's id
    
    static var users: [User] = []
    
    init(uid: Int) {
        self.uid = uid
    }
    
    static func loadUsers() {
        if users.count > 0 {
            return
        }
        let data: [User]? = load("users.json")
        if let data = data {
            users = data
        }
    }
    
    // TODO: fetch the de-facto result from the backend
    static func getUserById(_ id: Int) -> User? {
        loadUsers()
        return users.first(where: { $0.id == id })
    }
}
