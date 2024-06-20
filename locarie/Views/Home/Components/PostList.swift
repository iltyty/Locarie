//
//  PostList.swift
//  locarie
//
//  Created by qiuty on 23/02/2024.
//

import SwiftUI

struct PostList: View {
  let posts: [PostDto]
  var onFullscreenTapped: (_ i: Int) -> Void = { _ in }
  var onThumbnailTapped: (_ i: Int) -> Void = { _ in }
  @Binding var scrollId: Int64?

  var title = "Explore"
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
    VStack(spacing: 20) {
      if showTitle {
        titleView.id(-1)
      }
      postList
    }
  }

  private var titleView: some View {
    Text(title)
      .font(.custom(GlobalConstants.fontName, size: 18))
      .fontWeight(.bold)
  }

  @ViewBuilder
  private var postList: some View {
    if posts.isEmpty {
      emptyList
    } else {
      VStack(spacing: 0) {
        ForEach(posts.indices, id: \.self) { i in
          VStack(spacing: 0) {
            NavigationLink {
              BusinessHomePage(uid: posts[i].user.id)
            } label: {
              PostCardView(posts[i])
            }
            .id(i)
            .tint(.primary)
            .buttonStyle(.plain)
            .padding(.bottom, 16)

            if i != posts.count - 1 {
              Divider()
                .foregroundStyle(LocarieColor.greyMedium)
                .padding(.bottom, 16)
            }
          }
        }
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
