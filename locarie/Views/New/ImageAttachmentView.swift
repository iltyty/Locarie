//
//  ImageAttachmentView.swift
//  locarie
//
//  Created by qiuty on 2023/11/7.
//

import PhotosUI
import SwiftUI

struct ImageAttachmentView: View {
  let imageSize: CGFloat
  @ObservedObject var imageAttachment: PhotoViewModel.ImageAttachment

  var body: some View {
    HStack {
      switch imageAttachment.status {
      case let .finished(image):
        image.resizable()
          .scaledToFill()
          .frame(width: imageSize, height: imageSize)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 5))
      case .failed:
        Image(systemName: "exclamationmark.triangle.fill")
      default:
        ProgressView()
      }
    }.task {
      await imageAttachment.loadImage()
    }
  }
}

#Preview {
  ImageAttachmentView(
    imageSize: 50,
    imageAttachment: PhotoViewModel.ImageAttachment(
      PhotosPickerItem(itemIdentifier: "123")
    )
  )
}
