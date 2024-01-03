//
//  ImageAttachmentView.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import PhotosUI
import SwiftUI

struct ImageAttachmentView: View {
  let size: CGFloat
  let isCircle: Bool

  @ObservedObject var imageAttachment: PhotoViewModel.ImageAttachment

  init(
    size: CGFloat,
    isCircle: Bool = false,
    attachment: PhotoViewModel.ImageAttachment
  ) {
    self.size = size
    self.isCircle = isCircle
    imageAttachment = attachment
  }

  var body: some View {
    HStack {
      switch imageAttachment.status {
      case let .finished(image):
        finishedImage(image)
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
      .frame(width: size, height: size)
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
      .frame(width: size, height: size)
  }

  private var progressView: some View {
    ProgressView().frame(width: size, height: size)
  }
}

private enum Constants {
  static let cornerRadius = 5.0
}

#Preview {
  ImageAttachmentView(
    size: 50,
    attachment: PhotoViewModel.ImageAttachment(
      PhotosPickerItem(itemIdentifier: "123")
    )
  )
}
