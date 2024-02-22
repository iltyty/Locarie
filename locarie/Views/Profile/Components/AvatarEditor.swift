//
//  AvatarEditor.swift
//  locarie
//
//  Created by qiuty on 03/01/2024.
//

import PhotosUI
import SwiftUI

struct AvatarEditor: View {
  @ObservedObject var photoViewModel: PhotoViewModel

  @ObservedObject private var cacheViewModel = LocalCacheViewModel.shared

  var body: some View {
    VStack {
      avatar
      PhotosPicker(
        selection: $photoViewModel.selection,
        maxSelectionCount: 1,
        matching: .images,
        photoLibrary: .shared()
      ) { text }
    }
  }
}

private extension AvatarEditor {
  @ViewBuilder
  var avatar: some View {
    let avatarUrl = cacheViewModel.getAvatarUrl()
    if !photoViewModel.attachments.isEmpty {
      selectedImage()
    } else if !avatarUrl.isEmpty {
      avatar(avatarUrl)
    } else {
      defaultAvatar(size: Constants.avatarSize)
    }
  }

  func avatar(_ url: String) -> some View {
    AvatarView(imageUrl: url, size: Constants.avatarSize)
  }

  func selectedImage() -> some View {
    ImageAttachmentView(
      size: Constants.avatarSize,
      isCircle: true,
      attachment: photoViewModel.attachments[0]
    )
  }

  var text: some View {
    Text("Edit profile image")
      .foregroundStyle(Constants.textColor)
      .font(.footnote)
  }
}

private enum Constants {
  static let avatarSize: CGFloat = 64
  static let textColor: Color = .init(hex: 0x326AFB)
}

#Preview {
  AvatarEditor(photoViewModel: PhotoViewModel())
}
