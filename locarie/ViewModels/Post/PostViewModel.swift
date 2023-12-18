//
//  PostViewModel.swift
//  locarie
//
//  Created by qiuty on 2023/11/11.
//

import Foundation

// getAllPosts() -> [Post]
class PostViewModel: ObservableObject {
  var posts: [Post] = []
  var favoritePosts: [Post] = []

  init() {
    getAllPosts()
    getFavoritePosts()
  }

  func getAllPosts() {
    let data: [Post]? = load("posts.json")
    if let data {
      posts = data
    }
  }

  func getFavoritePosts(uid _: Int = 1) {
    favoritePosts = posts
  }

  func create() {}
}
