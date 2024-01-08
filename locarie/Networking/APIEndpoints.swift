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

  static let userLoginUrl = URL(string: userUrl + "/login")!
  static let userRegisterUrl = URL(string: userUrl + "/register")!
  static func userGetProfileUrl(id: Int64) -> URL {
    URL(string: userUrl + "/\(id)")!
  }

  static func userUpdateProfileUrl(id: Int64) -> URL {
    URL(string: userUrl + "/\(id)")!
  }

  static let postCreateUrl = URL(string: postUrl)!
  static let postListNearbyUrl = URL(string: postUrl + "/nearby")!
}
