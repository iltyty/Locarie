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

  @Published private(set) var cache = LocalCache.shared

  func clean() {
    cache.reset()
  }

  func isLoggedIn() -> Bool {
    cache.userId != 0
  }

  func getUserId() -> Int64 {
    Int64(cache.userId)
  }

  func getEmail() -> String {
    cache.email
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

  func isBusinessUser() -> Bool {
    cache.isBusinessUser()
  }

  func setAvatarUrl(_ url: String) {
    cache.setAvatarUrl(url)
  }

  func setUserInfo(_ info: UserInfo) {
    cache.setUserInfo(info)
  }

  func setEmail(_ email: String) {
    cache.setEmail(email)
  }

  func setUserCache(_ userCache: UserCache) {
    cache.setUserCache(userCache)
  }

  func isFirstLoggedIn() -> Bool {
    cache.firstLoggedIn
  }

  func setFirstLoggedIn(_ first: Bool) {
    cache.setFirstLoggedIn(first)
  }

  func isProfileComplete() -> Bool {
    cache.profileComplete
  }

  func setProfileComplete(_ complete: Bool) {
    cache.setProfileComplete(complete)
  }
}
