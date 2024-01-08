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

  @AppStorage(LocalCacheKeys.userIdKey)
  var userId = 0.0
  @AppStorage(LocalCacheKeys.userTypeKey)
  var userType = ""
  @AppStorage(LocalCacheKeys.usernameKey)
  var username = ""
  @AppStorage(LocalCacheKeys.jwtTokenKey)
  var jwtToken = ""
  @AppStorage(LocalCacheKeys.avatarUrlKey)
  var avatarUrl = ""

  private init() {}

  mutating func setUserInfo(_ info: UserInfo) {
    userId = info.id
    userType = info.type
    username = info.username
    jwtToken = info.jwtToken
    avatarUrl = info.avatarUrl ?? ""
  }

  func isRegularUser() -> Bool {
    userType == UserType.regular.rawValue
  }
}

enum LocalCacheKeys {
  static let userIdKey = "userId"
  static let userTypeKey = "userType"
  static let usernameKey = "username"
  static let avatarUrlKey = "avatarUrl"
  static let jwtTokenKey = "jwtToken"
}
