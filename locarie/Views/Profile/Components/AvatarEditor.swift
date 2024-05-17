//
//  AvatarEditor.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import PhotosUI
import SwiftUI

struct AvatarEditor: View {
  @ObservedObject var photoVM: PhotoViewModel
  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  @State private var uiImage: UIImage?
  @State private var croppedImage: UIImage?
  @State private var isCropping = false

  var body: some View {
    VStack {
      avatar
      PhotosPicker(
        selection: $photoVM.selection,
        maxSelectionCount: 1,
        matching: .images,
        photoLibrary: .shared()
      ) { text }
    }
    .fullScreenCover(isPresented: $isCropping) {
      ImageCropView(crop: .circle(Constants.imageCropSize), image: $uiImage) { image, _ in
        croppedImage = image
        if photoVM.attachments.count == 1 {
          photoVM.attachments.first!.data = image?.pngData() ?? image?.jpegData(compressionQuality: 1) ?? Data()
        }
      }
    }
    .onChange(of: photoVM.attachments) { _ in
      guard photoVM.attachments.count == 1 else {
        return
      }
      Task {
        let attachment = photoVM.attachments.first!
        await attachment.loadImage()
        DispatchQueue.main.async {
          if case let .finished(uiImage) = attachment.status {
            self.uiImage = uiImage
            isCropping = true
          }
        }
      }
    }
  }
}

private extension AvatarEditor {
  @ViewBuilder
  var avatar: some View {
    let avatarUrl = cacheVM.getAvatarUrl()
    if let croppedImage {
      Image(uiImage: croppedImage)
        .resizable()
        .scaledToFill()
        .frame(width: Constants.avatarSize, height: Constants.avatarSize)
        .clipShape(Circle())
    } else if !avatarUrl.isEmpty {
      avatar(avatarUrl)
    } else {
      defaultAvatar(size: Constants.avatarSize)
    }
  }

  func avatar(_ url: String) -> some View {
    AvatarView(imageUrl: url, size: Constants.avatarSize)
  }

  var text: some View {
    Text("Edit profile image")
      .foregroundStyle(Constants.textColor)
      .font(.footnote)
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 64
  static let imageCropSize: CGFloat = 350
  static let textColor: Color = .init(hex: 0x326AFB)
}

#Preview {
  AvatarEditor(photoVM: PhotoViewModel())
}
