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
  @AppStorage(LocalCacheKeys.avatarUrlKey)
  var avatarUrl = ""
  @AppStorage(LocalCacheKeys.jwtTokenKey)
  var jwtToken = ""

  private init() {}

  mutating func setUserInfo(_ info: UserInfo) {
    userId = info.id
    username = info.username
    jwtToken = info.jwtToken
  }
}
