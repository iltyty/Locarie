//
//  AvatarView.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct AvatarView: View {
  var name = ""
  var imageUrl = ""
  var size: CGFloat

  init(imageUrl: String? = "", size: CGFloat) {
    self.size = size
    self.imageUrl = imageUrl ?? ""
  }

  init(name: String, size: CGFloat) {
    self.size = size
    self.name = name
  }

  var body: some View {
    if !imageUrl.isEmpty {
      networkImage
    } else if !name.isEmpty {
      customImage
    } else {
      defaultAvatar(size: size)
    }
  }

  var networkImage: some View {
    AsyncImageView(url: imageUrl, width: size, height: size) { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
  }

  var customImage: some View {
    Image(name)
      .resizable()
      .scaledToFill()
      .frame(width: size, height: size)
      .clipShape(Circle())
  }
}

#Preview {
  VStack {
    AvatarView(size: 128)
    AvatarView(imageUrl: "https://picsum.photos/200", size: 128)
    AvatarView(name: "LoginBackground", size: 128)
  }
}
