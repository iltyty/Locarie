//
//  ProfileLink.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileLink: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label {
      linkText
    } icon: {
      Image(systemName: "link")
    }
  }

  @ViewBuilder
  var linkText: some View {
    let text = user.homepageUrl
    text.isEmpty
      ? Text("Link").foregroundStyle(.secondary)
      : Text(text)
  }
}
