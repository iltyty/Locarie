//
//  AvatarView.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import SwiftUI

struct AvatarView: View {
  let name: String
  let imageUrl: String
  let size: CGFloat
  let isBusiness: Bool

  init(imageUrl: String? = "", size: CGFloat, isBusiness: Bool = true) {
    name = ""
    self.imageUrl = imageUrl ?? ""
    self.size = size
    self.isBusiness = isBusiness
  }

  init(name: String, size: CGFloat, isBusiness: Bool = true) {
    self.name = name
    imageUrl = ""
    self.size = size
    self.isBusiness = isBusiness
  }

  var body: some View {
    if !imageUrl.isEmpty {
      networkImage
    } else if !name.isEmpty {
      customImage
    } else {
      defaultAvatar(size: size, isBusiness: isBusiness)
    }
  }

  var networkImage: some View {
    AsyncImageView(url: imageUrl, width: size, height: size) { image in
      image
        .resizable()
        .scaledToFill()
        .frame(size: size)
        .clipShape(Circle())
    }
    .frame(size: size)
  }

  var customImage: some View {
    Image(name)
      .resizable()
      .scaledToFill()
      .frame(size: size)
      .clipShape(Circle())
  }
}

#Preview {
  VStack {
    AvatarView(size: 128)
    AvatarView(imageUrl: "https://picsum.photos/200", size: 128)
  }
}
