//
//  ProfileOpeningHours.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileOpeningHours: View {
  let user: UserDto

  init(_ user: UserDto) {
    self.user = user
  }

  var body: some View {
    Label {
      openingHoursText
    } icon: {
      Image(systemName: "clock")
    }
    .lineLimit(1)
  }

  @ViewBuilder
  var openingHoursText: some View {
    let text = user.formattedBusinessHours
    text.isEmpty
      ? Text("Opening hours").foregroundStyle(.secondary)
      : Text(text)
  }
}
