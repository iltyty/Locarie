//
//  PostList.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct PostList: View {
  let posts: [PostDto]
  @Binding var selectedPost: PostDto
  @State var scrollId: Int64?

  var showTitle = true
  var emptyHint = "No post in this area"

  var body: some View {
    ScrollView {
      VStack {
        if showTitle {
          title.id(0)
        }
        postList
      }
      .scrollTargetLayout()
    }
    .scrollPosition(id: $scrollId)
    .scrollIndicators(.hidden)
    .onChange(of: selectedPost) { _, newValue in
      scrollId = newValue.id
    }
  }

  private var title: some View {
    ZStack {
      Text("Discover this area")
        .fontWeight(.semibold)
        .padding(.bottom)
    }
  }

  @ViewBuilder
  var postList: some View {
    Group {
      if posts.isEmpty {
        Text(emptyHint).foregroundStyle(.secondary)
      } else {
        ForEach(posts) { post in
          NavigationLink {
            BusinessHomePage(uid: post.user.id)
          } label: {
            PostCardView(post)
          }
          .id(post.id)
          .tint(.primary)
          .buttonStyle(.plain)
        }
      }
    }
  }
}
