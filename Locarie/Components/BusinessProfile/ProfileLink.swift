//
//  ProfileLink.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileLink: View {
  let user: UserDto

  @ObservedObject private var cacheVM = LocalCacheViewModel.shared

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label {
      linkText.buttonStyle(.plain).tint(.black)
    } icon: {
      Image("Link")
        .resizable()
        .scaledToFit()
        .frame(size: ProfileConstants.iconSize)
    }
  }

  @ViewBuilder
  var linkText: some View {
    let text = user.homepageUrl
    if #available(iOS 17.0, *) {
      text.isEmpty
        ? Text(cacheVM.getUserId() == user.id ? "Edit" : "Link").foregroundStyle(LocarieColor.greyDark)
        : Text(.init("[\(text)](\(textWithHttpsPrefix(text)))"))
    } else {
      text.isEmpty
        ? Text(cacheVM.getUserId() == user.id ? "Edit" : "Link").foregroundColor(LocarieColor.greyDark)
        : Text(.init("[\(text)](\(textWithHttpsPrefix(text)))"))
    }
  }

  func textWithoutHttpsPrefix(_ text: String) -> String {
    if text.starts(with: "https://") {
      String(text[text.index(text.startIndex, offsetBy: 8)...])
    } else {
      text
    }
  }

  func textWithHttpsPrefix(_ text: String) -> String {
    if text.starts(with: "https://") {
      text
    } else {
      "https://" + text
    }
  }
}
