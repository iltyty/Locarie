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
  private init() {}

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

  mutating func setUserInfo(_ info: UserInfo) {
    userId = Double(info.id)
    userType = info.type.rawValue
    username = info.username
    avatarUrl = info.avatarUrl
  }

  mutating func setUserCache(_ cache: UserCache) {
    setUserInfo(cache)
    jwtToken = cache.jwtToken
  }

  func isBusinessUser() -> Bool {
    userType == UserType.business.rawValue
  }

  mutating func setAvatarUrl(_ url: String) {
    avatarUrl = url
  }
}

enum LocalCacheKeys: String, CaseIterable {
  case userIdKey = "userId"
  case userTypeKey = "userType"
  case usernameKey = "username"
  case avatarUrlKey = "avatarUrl"
  case jwtTokenKey = "jwtToken"
}
