//
//  PostDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import CoreLocation
import Foundation

struct PostDto: Codable, Identifiable {
  let id: Int64
  let time: Date
  let title: String
  let content: String
  let user: UserDto
  let imageUrls: [String]
}

extension PostDto {
  var businessName: String {
    user.username
  }

  var businessAvatarUrl: String {
    user.avatarUrl
  }

  var businessLocationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: user.location?.latitude ?? .nan,
      longitude: user.location?.longitude ?? .nan
    )
  }
}

extension PostDto {
  var businessLocation: CLLocation {
    CLLocation(
      latitude: user.location?.latitude ?? .nan,
      longitude: user.location?.longitude ?? .nan
    )
  }

  var businessAddress: String {
    user.address
  }
}
