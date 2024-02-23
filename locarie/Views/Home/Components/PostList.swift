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
  var showTitle = true
  var emptyHint = "No post in this area"

  var body: some View {
    ScrollView {
      VStack {
        if showTitle {
          title
        }
        postList
      }
    }
  }

  private var title: some View {
    ZStack {
      Text("Discover this area")
        .fontWeight(.semibold)
        .padding(.bottom)
      HStack {
        Spacer()
        Link(destination: navigationUrl) {
          NavigationButton()
        }
      }
    }
  }

  var navigationUrl: URL {
    let coordinate = selectedPost.businessLocationCoordinate
    return URL(
      string: "https://www.google.com/maps?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=walking"
    )!
  }

  @ViewBuilder
  var postList: some View {
    if posts.isEmpty {
      Text(emptyHint)
        .foregroundStyle(.secondary)
    } else {
      ForEach(posts) { post in
        NavigationLink {
          PostDetailPage(uid: post.user.id)
        } label: {
          PostCardView(post)
        }
        .tint(.primary)
        .buttonStyle(.plain)
      }
    }
  }
}
