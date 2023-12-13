//
//  LocalCache.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Foundation
import SwiftUI

struct LocalCache {
    static var shared = LocalCache()

    @AppStorage(GlobalConstants.userIdKey)
    var userId = 0.0
    @AppStorage(GlobalConstants.userTypeKey)
    var userType = ""
    @AppStorage(GlobalConstants.usernameKey)
    var username = ""
    @AppStorage(GlobalConstants.avatarUrlKey)
    var avatarUrl = ""
    @AppStorage(GlobalConstants.jwtTokenKey)
    var jwtToken = ""

    private init() {}

    private func clear() {
        userId = 0
        username = ""
        jwtToken = ""
    }

    mutating func setUserInfo(_ info: UserInfo) {
        userId = info.id
        username = info.username
        jwtToken = info.jwtToken
    }
}
