//
//  ProfileBio.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileBio: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    ExpandableText(user.introduction.isEmpty ? "Go set up the profile!" : user.introduction, lineLimit: 3)
  }
}
