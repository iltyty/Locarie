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
      linkText
    } icon: {
      Image(systemName: "link")
        .font(.system(size: ProfileConstants.iconSize))
        .frame(width: ProfileConstants.iconSize, height: ProfileConstants.iconSize)
    }
  }

  @ViewBuilder
  var linkText: some View {
    let text = user.homepageUrl
    text.isEmpty
      ? Text(cacheVM.getUserId() == user.id ? "Go edit" : "Link").foregroundStyle(.secondary)
      : Text(text)
  }
}
