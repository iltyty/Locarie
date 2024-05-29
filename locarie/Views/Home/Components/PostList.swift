//
//  PostList.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct PostList: View {
  let posts: [PostDto]
  @Binding var scrollId: Int64?

  var showTitle = true
  var emptyHint = "No business yet"

  var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        scrollView.onChange(of: scrollId) { _ in
          proxy.scrollTo(0)
          scrollId = 1
        }
      }
    }
    .scrollIndicators(.hidden)
  }

  private var scrollView: some View {
    VStack {
      if showTitle {
        title.id(-1)
      }
      postList.padding(.bottom)
    }
  }

  private var title: some View {
    Text("Explore")
      .fontWeight(.semibold)
      .padding(.bottom)
  }

  @ViewBuilder
  private var postList: some View {
    if posts.isEmpty {
      emptyList
    } else {
      ForEach(posts.indices, id: \.self) { i in
        NavigationLink {
          BusinessHomePage(uid: posts[i].user.id)
        } label: {
          PostCardView(posts[i])
        }
        .id(i)
        .tint(.primary)
        .buttonStyle(.plain)
      }
    }
  }

  private var emptyList: some View {
    VStack {
      Image("NoBusiness")
      Text(emptyHint)
        .font(.custom(GlobalConstants.fontName, size: 14))
        .fontWeight(.bold)
        .foregroundStyle(LocarieColor.greyDark)
    }
    .padding(.top, Constants.paddingTop)
  }
}

private enum Constants {
  static let paddingTop: CGFloat = 50
}
