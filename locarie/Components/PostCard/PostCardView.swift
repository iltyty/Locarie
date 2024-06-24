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
  let onAvatarTapped: () -> Void
  let onCoverTapped: () -> Void
  let onThumbnailTapped: () -> Void
  @Binding var presentingDeleteDialog: Bool
  @Binding var deleteTargetPost: PostDto

  @State private var distance = "0 km away"
  @State private var deleteTapped = false
  @State private var presentingSheet = false
  @State private var presentingCover = false
  @ObservedObject private var locationManager = LocationManager()

  init(
    _ post: PostDto,
    divider: Bool = false,
    onAvatarTapped: @escaping () -> Void = {},
    onCoverTapped: @escaping () -> Void = {},
    onThumbnailTapped: @escaping () -> Void = {}
  ) {
    self.post = post
    self.divider = divider
    deletable = false
    self.onAvatarTapped = onAvatarTapped
    self.onCoverTapped = onCoverTapped
    self.onThumbnailTapped = onThumbnailTapped
    _presentingDeleteDialog = .constant(false)
    _deleteTargetPost = .constant(PostDto())
  }

  init(
    _ post: PostDto,
    divider: Bool = false,
    deletable: Bool = false,
    onAvatarTapped: @escaping () -> Void = {},
    onCoverTapped: @escaping () -> Void = {},
    onThumbnailTapped: @escaping () -> Void = {},
    presentingDeleteDialog: Binding<Bool>,
    deleteTargetPost: Binding<PostDto>
  ) {
    self.post = post
    self.divider = divider
    self.deletable = deletable
    self.onAvatarTapped = onAvatarTapped
    self.onCoverTapped = onCoverTapped
    self.onThumbnailTapped = onThumbnailTapped
    _presentingDeleteDialog = presentingDeleteDialog
    _deleteTargetPost = deleteTargetPost
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      status.padding(.bottom, 10)
      cover.padding(.bottom, 12)
      content.padding(.bottom, 12)
      categories.padding(.bottom, 16)
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
            .placeholder { SkeletonView(Constants.avatarSize, Constants.avatarSize, true) }
            .resizable()
            .frame(width: Constants.avatarSize, height: Constants.avatarSize)
            .clipShape(Circle())
        }
      }
      .onTapGesture { onAvatarTapped() }
      VStack(alignment: .leading, spacing: 2) {
        Text(post.businessName)
        HStack(spacing: 5) {
          Text(post.publishedTime)
            .foregroundStyle(post.publishedOneDayAgo ? LocarieColor.greyDark : LocarieColor.green)
          DotView()
          Text(post.user.neighborhood).foregroundStyle(LocarieColor.greyDark)
        }
        .font(.custom(GlobalConstants.fontName, size: 14))
      }
      Spacer()
      if deletable {
        Image(systemName: "ellipsis")
          .resizable()
          .scaledToFit()
          .frame(width: 16, height: 16)
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
  }

  var cover: some View {
    ZStack(alignment: .trailing) {
      Banner(urls: post.imageUrls, indicator: .inner, isPortrait: false)
      VStack(alignment: .trailing, spacing: 0) {
        Text(distance)
          .font(.custom(GlobalConstants.fontName, size: 12))
          .foregroundStyle(LocarieColor.greyDark)
          .padding(.horizontal, 10)
          .padding(.vertical, 5)
          .background(Capsule().fill(.white))
          .padding(5)
          .onReceive(locationManager.$location) { location in
            if let location {
              distance = "\(post.user.distance(to: location)) away"
            }
          }
        Spacer()
        if post.user.profileImageUrls.isEmpty {
          DefaultBusinessImageView(size: 48)
        } else {
          KFImage(URL(string: post.user.profileImageUrls[0]))
            .placeholder { SkeletonView(48, 48) }
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(1.5)
            .background { RoundedRectangle(cornerRadius: 16).fill(LocarieColor.greyMedium) }
            .padding(5)
            .onTapGesture { onThumbnailTapped() }
        }
      }
    }
    .onTapGesture { onCoverTapped() }
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

extension PostCardView {
  static var skeleton: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 10) {
        SkeletonView(40, 40, true)
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
  static let avatarSize: CGFloat = 40
  static let coverAspectRatio: CGFloat = 4 / 3
  static let coverBorderRadius: CGFloat = 10.0
  static let contentLineLimit = 2
}
