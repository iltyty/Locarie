//
//  ProfilePostsCount.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfilePostsCount: View {
  let posts: [PostDto]

  init(_ posts: [PostDto]) {
    self.posts = posts
  }

  @ViewBuilder
  var body: some View {
    Group {
      HStack(spacing: 0) {
        Text("\(posts.count) ")
        Text("posts")
      }
    }
  }
}
