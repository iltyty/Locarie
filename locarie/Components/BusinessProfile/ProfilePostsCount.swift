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
    Text("\(posts.count) post\(posts.count != 1 ? "s" : "")")
      .font(.custom(GlobalConstants.fontName, size: 14))
      .fontWeight(.bold)
      .foregroundStyle(LocarieColor.greyDark)
  }
}
