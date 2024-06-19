//
//  FavoriteEndpoints.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Foundation

extension APIEndpoints {
  static let favoritePostUrl = postsUrl + "/favorite"
  static let unfavoritePostUrl = postsUrl + "/unfavorite"
  static let postIsFavoredByUrl = postsUrl + "/is-favored-by"

  static let favoriteBusinessUrl = usersUrl + "/favorite"
  static let listFavoriteBusinessPostsUrl = favoriteBusinessUrl + "/posts"
  static let unfavoriteBusinessUrl = usersUrl + "/unfavorite"
  static let businessIsFavoredByUrl = usersUrl + "/is-favored-by"
}
