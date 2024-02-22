//
//  ProfileFavoredByCount.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileFavoredByCount: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label("\(user.favoredByCount)", systemImage: "bookmark")
  }
}
