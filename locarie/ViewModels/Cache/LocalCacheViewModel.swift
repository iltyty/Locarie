//
//  LocalCacheViewModel.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Foundation

class LocalCacheViewModel: ObservableObject {
  @Published var cache = LocalCache.shared

  func isLoggedIn() -> Bool {
    cache.userId != 0
  }

  func getUserId() -> Double {
    cache.userId
  }

  func getUserType() -> String {
    cache.userType
  }

  func getUsername() -> String {
    cache.username
  }

  func getAvatarUrl() -> String {
    cache.avatarUrl
  }

  func getJwtToken() -> String {
    cache.jwtToken
  }

  func setUserInfo(_ info: UserInfo) {
    cache.setUserInfo(info)
  }
}
