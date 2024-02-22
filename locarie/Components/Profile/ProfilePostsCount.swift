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
      if posts.isEmpty {
        HStack(spacing: 0) {
          Text("No ").foregroundStyle(Color.locariePrimary)
          Text("post yet")
        }
      } else {
        HStack(spacing: 0) {
          Text("\(posts.count) ").foregroundStyle(Color.locariePrimary)
          Text("posts")
        }
      }
    }
    .fontWeight(.semibold)
  }
}
