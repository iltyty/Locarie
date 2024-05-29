//
//  PostCover.swift
//  locarie
//
//  Created by qiuty on 21/02/2024.
//
import CoreLocation
import SwiftUI

struct PostCover: View {
  let post: PostDto
  let tags: [String]
  @Binding var isPresenting: Bool

  private let cacheVM = LocalCacheViewModel.shared
  private let locationManager = LocationManager()
  @State private var alreadySaved = false

  @StateObject private var postGetVM = PostGetViewModel()
  @StateObject private var favoritePostVM = FavoritePostViewModel()

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack(alignment: .leading) {
        coverTop
        ScrollView {
          VStack(alignment: .leading) {
            blank
            postStatus
            postImages
            content
            categories
            blank
          }
        }
        .padding(.bottom, 100)
      }
      ZStack(alignment: .bottomLeading) {
        favoriteButton
        if postGetVM.favoredByCount != 0 {
          favoredByCount
        }
      }
      .padding(.horizontal)
      .padding(.bottom, 30)
    }
    .padding(.horizontal)
    .background(.thickMaterial.opacity(CoverCommonConstants.backgroundOpacity))
    .contentShape(Rectangle())
    .onAppear {
      postGetVM.getFavoredByCount(id: post.id)
      favoritePostVM.checkFavoredBy(userId: userId, postId: post.id)
    }
    .onReceive(favoritePostVM.$alreadySaved) { saved in
      alreadySaved = saved
    }
    .onReceive(favoritePostVM.$state, perform: { state in
      switch state {
      case .favoriteFinished:
        postGetVM.favoredByCount += 1
        alreadySaved = true
      case .unfavoriteFinished:
        postGetVM.favoredByCount -= 1
        alreadySaved = false
      default: break
      }
    })
  }

  private var userId: Int64 {
    cacheVM.getUserId()
  }
}

private extension PostCover {
  var coverTop: some View {
    CoverTopView(
      user: post.user,
      sharePreviewText: post.content,
      isPresenting: $isPresenting
    )
  }

  var content: some View {
    Text(post.content).font(.headline)
  }

  var categories: some View {
    WrappingHStack {
      ForEach(tags, id: \.self) { tag in
        ProfileBusinessCategoryView(tag)
      }
    }
  }

  var blank: some View {
    Color
      .clear
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation(.spring) {
          isPresenting = false
        }
      }
  }

  var postImages: some View {
    Banner(urls: post.imageUrls, fullToggle: false, bottomIndicator: true).padding(.bottom)
  }

  var postStatus: some View {
    HStack {
      Text(post.publishedTime).foregroundStyle(.green)
      DotView()
      Text(post.user.distance(to: locationManager.location)).foregroundStyle(.secondary)
    }
  }

  var favoriteButton: some View {
    favoriteButtonBackground
      .overlay { favoriteIcon }
      .onTapGesture {
        if alreadySaved {
          favoritePostVM.unfavorite(userId: userId, postId: post.id)
        } else {
          favoritePostVM.favorite(userId: userId, postId: post.id)
        }
      }
  }

  var favoredByCount: some View {
    Text("\(postGetVM.favoredByCount)")
      .padding(.horizontal)
      .background(Capsule().fill(.background).shadow(radius: Constants.favoriteButtonShadowRadius))
      .offset(x: -Constants.favoriteButtonBackgroundSize / 2)
  }

  var favoriteIcon: some View {
    Image(systemName: favoriteIconSystemName)
      .resizable()
      .scaledToFit()
      .foregroundStyle(alreadySaved ? Color.locariePrimary : .primary)
      .frame(
        width: Constants.favoriteButtonIconSize,
        height: Constants.favoriteButtonIconSize
      )
  }

  var favoriteIconSystemName: String {
    if alreadySaved {
      "heart.fill"
    } else {
      "heart"
    }
  }

  var favoriteButtonBackground: some View {
    Circle()
      .fill(.background)
      .frame(
        width: Constants.favoriteButtonBackgroundSize,
        height: Constants.favoriteButtonBackgroundSize
      )
      .shadow(radius: Constants.favoriteButtonShadowRadius)
  }
}

private enum Constants {
  static let favoriteButtonShadowRadius: CGFloat = 2
  static let favoriteButtonIconSize: CGFloat = 28
  static let favoriteButtonBackgroundSize: CGFloat = 60
}
