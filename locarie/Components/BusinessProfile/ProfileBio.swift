//
//  ProfileBio.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileBio: View {
  let user: UserDto
  @Binding var presentingDetail: Bool

  init(_ user: UserDto, presentingDetail: Binding<Bool>) {
    self.user = user
    _presentingDetail = presentingDetail
  }

  var body: some View {
    let bio = user.introduction.isEmpty ? "Go set up the profile!" : user.introduction
    if presentingDetail {
      Text(bio)
    } else {
      Text(bio).lineLimit(2)
    }
  }
}
