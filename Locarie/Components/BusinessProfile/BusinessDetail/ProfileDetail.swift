//
//  ProfileDetail.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import SwiftUI

struct ProfileDetail: View {
  let user: UserDto
  let favoredByCount: Int
  let likedCount: Int

  init(_ user: UserDto, favoredByCount: Int, likedCount: Int) {
    self.user = user
    self.favoredByCount = favoredByCount
    self.likedCount = likedCount
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(spacing: 24) {
        ProfileFavoredByCount(favoredByCount)
        HStack(spacing: 10) {
          Image("Heart")
            .resizable()
            .scaledToFit()
            .frame(size: 16)
          Text("\(likedCount)")
        }
      }
      Link(destination: navigationUrl) {
        ProfileAddress(user)
      }
      .buttonStyle(.plain)
      if !user.businessHours.isEmpty {
        ProfileOpeningHours(user)
      }
      if !user.homepageUrl.isEmpty {
        ProfileLink(user)
      }
      if !user.phone.isEmpty {
        ProfilePhone(user)
      }
    }
  }

  var navigationUrl: URL {
    let destination = user.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    return URL(
      string: "https://www.google.com/maps/dir/?api=1&destination=\(destination)"
    )!
  }
}
