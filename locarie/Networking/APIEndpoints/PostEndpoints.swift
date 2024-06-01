//
//  PostEndpoints.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Foundation

extension APIEndpoints {
  static let postsUrl = baseUrl + "/posts"
  static let createPost = URL(string: postsUrl)!
  static let listPostsWithin = URL(string: postsUrl + "/within")!
  static let listPostsNearby = URL(string: postsUrl + "/nearby")!
  static let listPostsNearbyAll = URL(string: postsUrl + "/nearby-all")!
  static let getPostFavoredByCount = URL(string: postsUrl + "/favored-by/count")!
  static func listUserPosts(id: Int64) -> URL {
    URL(string: postsUrl + "/user/\(id)")!
  }
}
