//
//  PostEndpoints.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Foundation

extension APIEndpoints {
  static let postsUrl = baseUrl + "/posts"
  static let createPostUrl = URL(string: postsUrl)!
  static let listNearbyPosts = URL(string: postsUrl + "/nearby")!
  static func listUserPosts(id: Int64) -> URL {
    URL(string: postsUrl + "/user/\(id)")!
  }
}
