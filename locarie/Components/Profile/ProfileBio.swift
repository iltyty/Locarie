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
    var bio = user.introduction
    if bio.isEmpty {
      bio = "Go set up the profile!"
    }
    return Text(bio).foregroundStyle(.secondary).lineLimit(2)
  }
}
