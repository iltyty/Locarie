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
  @Binding var isPresenting: Bool

  private let cacheVM = LocalCacheViewModel.shared
  private let locationManager = LocationManager()
  @State private var alreadySaved = false
  @StateObject private var favoritePostVM = FavoritePostViewModel()

  var body: some View {
    VStack(alignment: .leading) {
      coverTop
      blank
      content
      postImages
      postStatus
      blank
      favoriteButton
      blank
    }
    .padding(.horizontal)
    .background(.thickMaterial.opacity(CoverCommonConstants.backgroundOpacity))
    .contentShape(Rectangle())
    .onAppear {
      favoritePostVM.checkFavoredBy(userId: userId, postId: post.id)
    }
    .onReceive(favoritePostVM.$alreadySaved) { saved in
      alreadySaved = saved
    }
    .onReceive(favoritePostVM.$state, perform: { state in
      switch state {
      case .favoriteFinished:
        alreadySaved = true
      case .unfavoriteFinished:
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
    Banner(urls: post.imageUrls).padding(.bottom)
  }

  var postStatus: some View {
    HStack {
      Text(post.publishedTime).foregroundStyle(.green)
      Text("·")
      Text(post.user.distance(to: locationManager.location)).foregroundStyle(.secondary)
    }
  }

  var favoriteButton: some View {
    HStack {
      Spacer()
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
      "star.fill"
    } else {
      "star"
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
