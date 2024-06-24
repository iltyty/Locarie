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
  private(set) var userId = 0.0
  @AppStorage(LocalCacheKeys.userTypeKey.rawValue)
  private(set) var userType = ""
  @AppStorage(LocalCacheKeys.usernameKey.rawValue)
  private(set) var username = ""
  @AppStorage(LocalCacheKeys.jwtTokenKey.rawValue)
  private(set) var jwtToken = ""
  @AppStorage(LocalCacheKeys.avatarUrlKey.rawValue)
  private(set) var avatarUrl = ""

  @AppStorage(LocalCacheKeys.firstLoggedInKey.rawValue)
  private(set) var firstLoggedIn = true

  @AppStorage(LocalCacheKeys.avatarId.rawValue)
  private(set) var avatarId = ""

  @AppStorage(LocalCacheKeys.profileComplete.rawValue)
  private(set) var profileComplete = false

  mutating func setUserInfo(_ info: UserInfo) {
    userId = Double(info.id)
    userType = info.type.rawValue
    username = info.username
    avatarUrl = info.avatarUrl
    avatarId = UUID().uuidString
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
    avatarId = UUID().uuidString
  }

  mutating func setFirstLoggedIn(_ first: Bool) {
    firstLoggedIn = first
  }

  mutating func setProfileComplete(_ complete: Bool) {
    profileComplete = complete
  }

  mutating func reset() {
    userId = 0
    userType = ""
    username = ""
    jwtToken = ""
    avatarUrl = ""
    firstLoggedIn = true
    avatarId = ""
    profileComplete = false
  }
}

enum LocalCacheKeys: String, CaseIterable {
  case userIdKey = "userId"
  case userTypeKey = "userType"
  case usernameKey = "username"
  case avatarUrlKey = "avatarUrl"
  case jwtTokenKey = "jwtToken"

  case firstLoggedInKey = "firstLoggedIn"

  case avatarId

  case profileComplete
}
