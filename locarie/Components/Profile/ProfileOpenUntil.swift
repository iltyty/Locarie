//
//  ProfileOpenUntil.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileOpenUntil: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label(user.openUtil, systemImage: "clock")
  }
}
