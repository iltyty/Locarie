//
//  APIEndpoints.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Foundation

enum APIEndpoints {
  static let baseUrl = "http://localhost:8080/api/v1"
  static let usersUrl = baseUrl + "/users"
  static let postsUrl = baseUrl + "/posts"

  static func userUrl(id: Int64) -> URL {
    URL(string: usersUrl + "/\(id)")!
  }

  static let userLoginUrl = URL(string: usersUrl + "/login")!
  static let userRegisterUrl = URL(string: usersUrl + "/register")!
  static let listBusinessesUrl = URL(string: usersUrl + "/businesses")!

  static let favoritePostUrl = postsUrl + "/favorite"
  static let unfavoritePostUrl = postsUrl + "/unfavorite"
  static let postIsFavoredByUrl = postsUrl + "/is-favored-by"

  static let favoriteBusinessUrl = usersUrl + "/favorite"
  static let unfavoriteBusinessUrl = usersUrl + "/unfavorite"
  static let businessIsFavoredByUrl = usersUrl + "/is-favored-by"

  static func userAvatarUrl(id: Int64) -> URL {
    URL(string: usersUrl + "/\(id)/avatar")!
  }

  static func userProfileImagesUrl(id: Int64) -> URL {
    URL(string: usersUrl + "/\(id)/profile-images")!
  }

  static let createPostUrl = URL(string: postsUrl)!
  static let listNearbyPosts = URL(string: postsUrl + "/nearby")!
  static func listUserPosts(id: Int64) -> URL {
    URL(string: postsUrl + "/user/\(id)")!
  }
}
