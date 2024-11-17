//
//  AvatarEditor.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import Kingfisher
import PhotosUI
import SwiftUI

struct AvatarEditor: View {
  @ObservedObject var photoVM: PhotoViewModel
  @Binding var modified: Bool

  @State private var uiImage: UIImage?
  @State private var croppedImage: UIImage?
  @State private var isCropping = false
  
  private let cacheVM = LocalCacheViewModel.shared

  var body: some View {
    VStack(spacing: 10) {
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
          modified = true
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
        .frame(size: Constants.avatarSize)
        .clipShape(Circle())
    } else if !avatarUrl.isEmpty {
      avatar(avatarUrl)
    } else {
      defaultAvatar(size: Constants.avatarSize, isBusiness: cacheVM.isBusinessUser())
    }
  }

  func avatar(_ url: String) -> some View {
    KFImage(URL(string: url))
      .placeholder { SkeletonView(Constants.avatarSize, Constants.avatarSize, true) }
      .resizable()
      .frame(size: Constants.avatarSize)
      .clipShape(Circle())
  }

  var text: some View {
    Text("Edit profile image")
      .font(.custom(GlobalConstants.fontName, size: 14))
      .foregroundStyle(LocarieColor.blue)
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 64
  static let imageCropSize: CGFloat = 350
}
