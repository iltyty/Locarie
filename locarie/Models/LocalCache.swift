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

  @AppStorage(LocalCacheKeys.userIdKey.rawValue)
  var userId = 0.0
  @AppStorage(LocalCacheKeys.userTypeKey.rawValue)
  var userType = ""
  @AppStorage(LocalCacheKeys.usernameKey.rawValue)
  var username = ""
  @AppStorage(LocalCacheKeys.jwtTokenKey.rawValue)
  var jwtToken = ""
  @AppStorage(LocalCacheKeys.avatarUrlKey.rawValue)
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

enum LocalCacheKeys: String, CaseIterable {
  case userIdKey = "userId"
  case userTypeKey = "userType"
  case usernameKey = "username"
  case avatarUrlKey = "avatarUrl"
  case jwtTokenKey = "jwtToken"
}
