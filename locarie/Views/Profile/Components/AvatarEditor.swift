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
    PhotosPicker(
      selection: $photoViewModel.selection,
      maxSelectionCount: 1,
      matching: .images,
      photoLibrary: .shared()
    ) { getAvatar() }
  }
}

private extension AvatarEditor {
  @ViewBuilder
  func getAvatar() -> some View {
    let avatarUrl = cacheViewModel.getAvatarUrl()
    if !avatarUrl.isEmpty {
      avatar(avatarUrl)
    } else if !photoViewModel.attachments.isEmpty {
      selectedImage()
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
}

private enum Constants {
  static let avatarSize = 64.0
}

#Preview {
  AvatarEditor(photoViewModel: PhotoViewModel())
}
