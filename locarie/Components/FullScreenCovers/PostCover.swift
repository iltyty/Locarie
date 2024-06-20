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
  var onAvatarTapped: () -> Void = {}
  var onPostDeleted: (Int64) -> Void = { _ in }
  @Binding var isPresenting: Bool

  private let cacheVM = LocalCacheViewModel.shared
  private let locationManager = LocationManager()

  @State private var alreadySaved = false
  @State private var deleteTapped = false
  @State private var presentingDeleteAlert = false
  @State private var presentingDeleteSheet = false

  @StateObject private var postGetVM = PostGetViewModel()
  @StateObject private var postDeleteVM = PostDeleteViewModel()
  @StateObject private var favoritePostVM = FavoritePostViewModel()

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack(alignment: .leading, spacing: 0) {
        CoverTopView(
          user: post.user,
          sharePreviewText: post.content,
          onAvatarTapped: onAvatarTapped,
          onMoreButtonTapped: {
            if post.user.id == cacheVM.getUserId() {
              presentingDeleteSheet = true
            }
          },
          isPresenting: $isPresenting
        )
        .padding(.bottom, 24)
        .padding(.horizontal, 8)
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            postStatus
            VStack(alignment: .leading, spacing: 10) {
              Banner(urls: post.imageUrls, fullToggle: false, indicator: .bottom).padding(.bottom)
              Text(post.content).font(.headline)
            }
            HStack(spacing: 5) {
              ForEach(tags, id: \.self) { tag in
                ProfileBusinessCategoryView(tag)
              }
            }
          }
        }
        Spacer()
      }
      ZStack(alignment: .bottomLeading) {
        favoriteButton
        if postGetVM.favoredByCount != 0 {
          favoredByCount
        }
      }
      .padding(.horizontal, 8)
      .padding(.bottom, 36)
    }
    .padding(.horizontal, 16)
    .background(.ultraThinMaterial.opacity(0.95))
    .alert("Confirm deletion", isPresented: $presentingDeleteAlert) {
      Button("Delete", role: .destructive) {
        postDeleteVM.delete(id: post.id)
      }
    }
    .bottomDialog(isPresented: $presentingDeleteSheet) {
      if deleteTapped {
        presentingDeleteAlert = true
      }
    } content: {
      VStack(spacing: 5) {
        bottomDialogButtonBuilder("Delete post") {
          deleteTapped = true
          presentingDeleteSheet = false
        }
        .foregroundStyle(.red)
        bottomDialogButtonBuilder("Back") {
          presentingDeleteSheet = false
        }
        Spacer()
      }
      .padding(.horizontal, 16)
    }
    .onAppear {
      postGetVM.getFavoredByCount(id: post.id)
      favoritePostVM.checkFavoredBy(userId: userId, postId: post.id)
    }
    .onReceive(favoritePostVM.$alreadySaved) { saved in
      alreadySaved = saved
    }
    .onReceive(postDeleteVM.$state) { state in
      switch state {
      case .finished:
        isPresenting = false
        onPostDeleted(post.id)
      default:
        return
      }
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

  var postStatus: some View {
    HStack(spacing: 5) {
      Text(post.publishedTime)
        .foregroundStyle(post.publishedOneDayAgo ? LocarieColor.greyDark : LocarieColor.green)
      DotView()
      Text(post.user.distance(to: locationManager.location))
        .foregroundStyle(LocarieColor.greyDark)
      DotView()
      Text(post.user.neighborhood).foregroundStyle(LocarieColor.greyDark)
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
      .padding(.vertical, 2)
      .padding(.horizontal, 16)
      .background(Capsule().fill(.white).shadow(radius: Constants.favoriteButtonShadowRadius))
      .offset(x: -Constants.favoriteButtonBackgroundSize / 2)
  }

  var favoriteIcon: some View {
    Image(favoriteIconName)
      .resizable()
      .scaledToFit()
      .foregroundStyle(alreadySaved ? Color.locariePrimary : .primary)
      .frame(
        width: Constants.favoriteButtonIconSize,
        height: Constants.favoriteButtonIconSize
      )
  }

  var favoriteIconName: String {
    if alreadySaved {
      "Heart.Fill"
    } else {
      "Heart"
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
