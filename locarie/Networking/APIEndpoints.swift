//
//  APIEndpoints.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Foundation

enum APIEndpoints {
  static let baseUrl = "http://localhost:8080/api/v1"
  static let userUrl = baseUrl + "/users"
  static let postUrl = baseUrl + "/posts"

  static let favoritePostUrl = postUrl + "/favorite"
  static let unfavoritePostUrl = postUrl + "/unfavorite"
  static let postIsFavoredByUrl = postUrl + "/is-favored-by"

  static let favoriteBusinessUrl = userUrl + "/favorite"
  static let unfavoriteBusinessUrl = userUrl + "/unfavorite"
  static let businessIsFavoredByUrl = userUrl + "/is-favored-by"

  static let userLoginUrl = URL(string: userUrl + "/login")!
  static let userRegisterUrl = URL(string: userUrl + "/register")!
  static func userProfileUrl(id: Int64) -> URL {
    URL(string: userUrl + "/\(id)")!
  }

  static func userAvatarUrl(id: Int64) -> URL {
    URL(string: userUrl + "/\(id)/avatar")!
  }

  static func userProfileImagesUrl(id: Int64) -> URL {
    URL(string: userUrl + "/\(id)/profile-images")!
  }

  static let createPostUrl = URL(string: postUrl)!
  static let listNearbyPosts = URL(string: postUrl + "/nearby")!
  static func listUserPosts(id: Int64) -> URL {
    URL(string: postUrl + "/user/\(id)")!
  }
}
