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
    HStack(spacing: 10) {
      Image("Bookmark")
        .resizable()
        .scaledToFit()
        .frame(width: 16, height: 16)
      Text("\(user.favoredByCount)")
    }
  }
}
