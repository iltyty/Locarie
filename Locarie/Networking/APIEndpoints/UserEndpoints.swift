//
//  UserEndpoints.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Foundation

extension APIEndpoints {
  static let usersUrl = baseUrl + "/users"
  static let userLoginUrl = URL(string: usersUrl + "/login")!
  static let userRegisterUrl = URL(string: usersUrl + "/register")!
  static let listBusinessesUrl = URL(string: usersUrl + "/businesses")!

  static func userUrl(id: Int64) -> URL {
    URL(string: usersUrl + "/\(id)")!
  }

  static func userAvatarUrl(id: Int64) -> URL {
    URL(string: usersUrl + "/\(id)/avatar")!
  }

  static func userProfileImagesUrl(id: Int64) -> URL {
    URL(string: usersUrl + "/\(id)/profile-images")!
  }
}
