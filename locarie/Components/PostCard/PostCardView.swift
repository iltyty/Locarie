//
//  PostCardView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import SwiftUI

struct PostCardView: View {
  let post: PostDto
  let deletable: Bool
  let onFullscreenTapped: () -> Void
  let onThumbnailTapped: () -> Void
  @Binding var presentingDeleteDialog: Bool
  @Binding var deleteTargetPost: PostDto

  @State private var deleteTapped = false
  @State private var presentingSheet = false
  @State private var presentingCover = false
  @StateObject private var locationManager = LocationManager()

  init(_ post: PostDto, onFullscreenTapped: @escaping () -> Void = {}, onThumbnailTapped: @escaping () -> Void = {}) {
    self.post = post
    deletable = false
    self.onFullscreenTapped = onFullscreenTapped
    self.onThumbnailTapped = onThumbnailTapped
    _presentingDeleteDialog = .constant(false)
    _deleteTargetPost = .constant(PostDto())
  }

  init(
    _ post: PostDto,
    deletable: Bool = false,
    onFullscreenTapped: @escaping () -> Void = {},
    onThumbnailTapped: @escaping () -> Void = {},
    presentingDeleteDialog: Binding<Bool>,
    deleteTargetPost: Binding<PostDto>
  ) {
    self.post = post
    self.deletable = deletable
    self.onFullscreenTapped = onFullscreenTapped
    self.onThumbnailTapped = onThumbnailTapped
    _presentingDeleteDialog = presentingDeleteDialog
    _deleteTargetPost = deleteTargetPost
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      status.padding(.bottom, 9)
      cover.padding(.bottom, 16)
      content.padding(.bottom, 10)
      categories
    }
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: Constants.coverBorderRadius).fill(.background)
  }
}

private extension PostCardView {
  var status: some View {
    HStack(spacing: 10) {
      userAvatar
      VStack(alignment: .leading, spacing: 0) {
        Text(post.businessName)
        HStack(spacing: 5) {
          Text(post.publishedTime)
            .foregroundStyle(post.publishedOneDayAgo ? LocarieColor.greyDark : LocarieColor.green)
          DotView()
          Text(post.user.neighborhood)
            .foregroundStyle(LocarieColor.greyDark)
        }
        .font(.custom(GlobalConstants.fontName, size: 14))
      }
      Spacer()
      if deletable {
        Image(systemName: "ellipsis")
          .resizable()
          .scaledToFit()
          .frame(width: 16, height: 16)
          .sheet(isPresented: $presentingSheet) {
            if deleteTapped {
              deleteTargetPost = post
              presentingDeleteDialog = true
            }
          } content: {
            if #available(iOS 16.4, *) {
              sheetContent.presentationCornerRadius(24)
            } else {
              sheetContent
            }
          }
          .contentShape(Rectangle())
          .onTapGesture {
            presentingSheet = true
          }
      }
    }
  }

  var sheetContent: some View {
    ZStack {
      LocarieColor.greyMedium
      VStack(spacing: 5) {
        Capsule()
          .fill(Color(hex: 0xD9D9D9))
          .frame(width: 48, height: 6)
          .padding(.top, 6)
          .padding(.bottom, 11)
        sheetButtonBuilder("Delete post") {
          deleteTapped = true
          presentingSheet = false
        }
        .foregroundStyle(.red)
        sheetButtonBuilder("Back") {
          presentingSheet = false
        }
        Spacer()
      }
      .padding(.horizontal, 16)
    }
    .ignoresSafeArea(edges: .bottom)
    .presentationDetents([.height(150)])
    .presentationDragIndicator(.hidden)
  }

  func sheetButtonBuilder(_ title: String, action: @escaping () -> Void) -> some View {
    Text(title)
      .fontWeight(.bold)
      .frame(height: 48)
      .frame(maxWidth: .infinity)
      .background {
        RoundedRectangle(cornerRadius: 30).fill(.white).frame(maxWidth: .infinity)
      }
      .onTapGesture {
        action()
      }
  }

  var cover: some View {
    ZStack(alignment: .trailing) {
      Banner(urls: post.imageUrls, isPortrait: false)
      VStack(alignment: .trailing, spacing: 0) {
        Image("Fullscreen")
          .resizable()
          .scaledToFit()
          .frame(width: 30, height: 30)
          .padding(8)
          .contentShape(Rectangle())
          .onTapGesture {
            onFullscreenTapped()
          }
        Spacer()
        if post.user.profileImageUrls.isEmpty {
          DefaultBusinessImageView(size: 48)
        } else {
          AsyncImage(url: URL(string: post.user.profileImageUrls[0])) { image in
            image
              .resizable()
              .scaledToFill()
              .frame(width: 48, height: 48)
              .clipShape(RoundedRectangle(cornerRadius: 16))
          } placeholder: {
            DefaultBusinessImageView(size: 48)
          }
          .padding(2)
          .background {
            RoundedRectangle(cornerRadius: 16)
              .strokeBorder(LocarieColor.greyMedium, style: .init(lineWidth: 2))
          }
          .padding(5)
          .onTapGesture {
            onThumbnailTapped()
          }
        }
      }
    }
  }

  var content: some View {
    Text(post.content)
      .lineLimit(Constants.contentLineLimit)
      .listRowSeparator(.hidden)
  }

  var categories: some View {
    ProfileCategories(post.user)
  }
}

private extension PostCardView {
  var userAvatar: some View {
    AvatarView(imageUrl: post.businessAvatarUrl, size: Constants.avatarSize)
  }

  var distance: Double {
    guard let location = locationManager.location else { return 0 }
    return location.distance(from: post.businessLocation)
  }
}

extension PostCardView {
  static var skeleton: some View {
    GeometryReader { _ in
      VStack(alignment: .leading) {
        HStack {
          SkeletonView(24, 24, true)
          SkeletonView(60, 10)
          SkeletonView(146, 10)
        }
        defaultCover
        SkeletonView(280, 10)
        HStack {
          SkeletonView(68, 10)
          SkeletonView(68, 10)
        }
      }
    }
  }

  static var defaultCover: some View {
    RoundedRectangle(cornerRadius: 18)
      .fill(LocarieColor.greyMedium)
      .frame(height: 267)
      .frame(maxWidth: .infinity)
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 40
  static let coverAspectRatio: CGFloat = 4 / 3
  static let coverBorderRadius: CGFloat = 10.0
  static let contentLineLimit = 2
}
