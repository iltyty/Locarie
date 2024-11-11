//
//  PostCardView.swift
//  locarie
//
//  Created by qiuty on 2023/10/31.
//

import Kingfisher
import SwiftUI

struct PostCardView: View {
  let post: PostDto
  let divider: Bool
  let deletable: Bool
  let onTapped: () -> Void
  let onCoverTapped: () -> Void
  let onThumbnailTapped: () -> Void
  @Binding var presentingDeleteDialog: Bool
  @Binding var deleteTargetPost: PostDto

  @State private var distance = "0"
  @State private var deleteTapped = false
  @State private var presentingSheet = false
  @State private var presentingCover = false
  @ObservedObject private var locationManager = LocationManager()

  init(
    _ post: PostDto,
    divider: Bool = false,
    onTapped: @escaping () -> Void = {},
    onCoverTapped: @escaping () -> Void = {},
    onThumbnailTapped: @escaping () -> Void = {}
  ) {
    self.post = post
    self.divider = divider
    deletable = false
    self.onTapped = onTapped
    self.onCoverTapped = onCoverTapped
    self.onThumbnailTapped = onThumbnailTapped
    _presentingDeleteDialog = .constant(false)
    _deleteTargetPost = .constant(PostDto())
  }

  init(
    _ post: PostDto,
    divider: Bool = false,
    deletable: Bool = false,
    onTapped: @escaping () -> Void = {},
    onCoverTapped: @escaping () -> Void = {},
    onThumbnailTapped: @escaping () -> Void = {},
    presentingDeleteDialog: Binding<Bool>,
    deleteTargetPost: Binding<PostDto>
  ) {
    self.post = post
    self.divider = divider
    self.deletable = deletable
    self.onTapped = onTapped
    self.onCoverTapped = onCoverTapped
    self.onThumbnailTapped = onThumbnailTapped
    _presentingDeleteDialog = presentingDeleteDialog
    _deleteTargetPost = deleteTargetPost
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      status
        .padding(.bottom, 10)
        .onTapGesture { onTapped() }
      cover.padding(.bottom, 12)
      content.padding(.bottom, 12)
      categories.padding(.bottom, divider ? 16 : BackToMapButton.height + 48)
      if divider {
        LocarieDivider().padding(.bottom, 16)
      }
    }
  }

  private var background: some View {
    RoundedRectangle(cornerRadius: Constants.coverBorderRadius).fill(.background)
  }
}

private extension PostCardView {
  var status: some View {
    HStack(spacing: 10) {
      Group {
        if post.businessAvatarUrl.isEmpty {
          defaultAvatar(size: Constants.avatarSize, isBusiness: true)
        } else {
          KFImage(URL(string: post.businessAvatarUrl))
            .downsampling(size: .init(size: 4 * Constants.avatarSize))
            .cacheOriginalImage()
            .placeholder { SkeletonView(Constants.avatarSize, Constants.avatarSize, true) }
            .resizable()
            .frame(size: Constants.avatarSize)
            .clipShape(Circle())
        }
      }
      VStack(alignment: .leading, spacing: 2) {
        Text(post.businessName).fontWeight(.bold)
        HStack(spacing: 5) {
          Text(post.user.neighborhood).foregroundStyle(LocarieColor.greyDark)
          DotView()
          Text(post.publishedTime)
            .foregroundStyle(post.publishedOneDayAgo ? LocarieColor.greyDark : LocarieColor.green)
        }
        .font(.custom(GlobalConstants.fontName, size: 14))
      }
      Spacer()
      if deletable {
        Image(systemName: "ellipsis")
          .resizable()
          .scaledToFit()
          .frame(size: 16)
          .bottomDialog(isPresented: $presentingSheet) {
            if deleteTapped {
              deleteTargetPost = post
              presentingDeleteDialog = true
            }
          } content: {
            VStack(spacing: 5) {
              bottomDialogButtonBuilder("Delete post") {
                deleteTapped = true
                presentingSheet = false
              }
              .foregroundStyle(.red)
              bottomDialogButtonBuilder("Back") {
                presentingSheet = false
              }
              Spacer()
            }
            .padding(.horizontal, 16)
          }
          .contentShape(Rectangle())
          .onTapGesture {
            presentingSheet = true
          }
      }
    }
    .contentShape(Rectangle())
  }

  var cover: some View {
    ZStack(alignment: .trailing) {
      Banner(urls: post.imageUrls, indicator: .inner, isPortrait: false)
      VStack(alignment: .trailing, spacing: 0) {
        DistanceView(user: post.user)
        Spacer()
        if post.user.profileImageUrls.isEmpty {
          DefaultBusinessImageView(size: 48).shadow(color: Color.black.opacity(0.25), radius: 2, x: 0.25, y: 0.25)
        } else {
          KFImage(URL(string: post.user.profileImageUrls[0]))
            .downsampling(size: .init(size: 48 * 8))
            .cacheOriginalImage()
            .placeholder { SkeletonView(48, 48) }
            .resizable()
            .scaledToFill()
            .frame(size: 48)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(1.5)
            .background {
              RoundedRectangle(cornerRadius: 16)
                .fill(LocarieColor.greyMedium)
                .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0.25, y: 0.25)
            }
            .padding(5)
            .onTapGesture { onThumbnailTapped() }
        }
      }
    }
    .onTapGesture { onCoverTapped() }
  }

  var content: some View {
    ExpandableText(post.content, lineLimit: Constants.postContentMaxLint)
  }

  var categories: some View {
    HStack {
      ProfileCategories(post.user)
      Spacer()
    }
    .contentShape(Rectangle())
  }
}

extension PostCardView {
  static var skeleton: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 10) {
        SkeletonView(Constants.avatarSize, Constants.avatarSize, true)
        VStack(alignment: .leading, spacing: 10) {
          SkeletonView(60, 10)
          SkeletonView(146, 10)
        }
      }
      .padding(.bottom, 10)
      defaultCover.padding(.bottom, 16)
      SkeletonView(280, 10).padding(.bottom, 10)
      HStack(spacing: 5) {
        SkeletonView(68, 10)
        SkeletonView(68, 10)
      }
      .padding(.bottom, 16)
      LocarieDivider()
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
  static let avatarSize: CGFloat = 34
  static let coverAspectRatio: CGFloat = 4 / 3
  static let coverBorderRadius: CGFloat = 10.0
  static let contentLineLimit = 2
  static let postContentMaxLint = 2
}

#Preview {
  PostCardView.skeleton
}
