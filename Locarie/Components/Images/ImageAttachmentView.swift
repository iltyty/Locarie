//
//  ImageAttachmentView.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import PhotosUI
import SwiftUI

struct ImageAttachmentView: View {
  let width: CGFloat
  let height: CGFloat
  let isCircle: Bool

  @ObservedObject var imageAttachment: PhotoViewModel.ImageAttachment

  init(
    size: CGFloat,
    isCircle: Bool = false,
    attachment: PhotoViewModel.ImageAttachment
  ) {
    width = size
    height = size
    self.isCircle = isCircle
    imageAttachment = attachment
  }

  init(
    width: CGFloat,
    height: CGFloat,
    attachment: PhotoViewModel.ImageAttachment
  ) {
    self.width = width
    self.height = height
    isCircle = false
    imageAttachment = attachment
  }

  init(
    width: CGFloat,
    aspectRatio: CGFloat,
    attachment: PhotoViewModel.ImageAttachment
  ) {
    self.width = width
    height = width / aspectRatio
    isCircle = false
    imageAttachment = attachment
  }

  var body: some View {
    Group {
      switch imageAttachment.status {
      case let .finished(uiImage):
        finishedImage(Image(uiImage: uiImage))
      case .failed:
        failedImage
      default:
        progressView
      }
    }.task {
      await imageAttachment.loadImage()
    }
  }

  @ViewBuilder
  private func finishedImage(_ image: Image) -> some View {
    let clippedImage = image.resizable()
      .scaledToFill()
      .frame(width: width, height: height)
      .clipped()
    if isCircle {
      clippedImage.clipShape(Circle())
    } else {
      clippedImage
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
  }

  private var failedImage: some View {
    Image(systemName: "exclamationmark.triangle.fill")
      .frame(width: width, height: height)
  }

  private var progressView: some View {
    ProgressView().frame(width: width, height: height)
  }
}

private enum Constants {
  static let cornerRadius: CGFloat = 18
}
