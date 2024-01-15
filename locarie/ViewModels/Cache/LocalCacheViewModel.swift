//
//  LocalCacheViewModel.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Foundation

class LocalCacheViewModel: ObservableObject {
  static let shared = LocalCacheViewModel()
  private init() {}

  @Published var cache = LocalCache.shared

  func clean() {
    UserDefaults.standard.reset()
  }

  func isLoggedIn() -> Bool {
    cache.userId != 0
  }

  func getUserId() -> Int64 {
    Int64(cache.userId)
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

  func isRegularUser() -> Bool {
    cache.isRegularUser()
  }

  func setAvatarUrl(_ url: String) {
//    cache.avatarUrl = avatarUrl
    cache.setAvatarUrl(url)
  }

  func setUserInfo(_ info: UserInfo) {
    cache.setUserInfo(info)
  }

  func setUserCache(_ userCache: UserCache) {
    cache.setUserCache(userCache)
  }
}
