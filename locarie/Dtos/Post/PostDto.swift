//
//  PostDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import CoreLocation
import Foundation

struct PostDto: Codable, Identifiable {
  var id: Int64 = 0
  var time = Date()
  var content = ""
  var user = UserDto()
  var imageUrls: [String] = []
}

extension PostDto {
  var businessName: String {
    user.businessName
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

  var businessLocation: CLLocation {
    CLLocation(
      latitude: user.location?.latitude ?? .nan,
      longitude: user.location?.longitude ?? .nan
    )
  }

  var businessAddress: String {
    user.address
  }

  var openUtil: String {
    user.openUtil
  }
}

extension PostDto {
  enum CodingKeys: String, CodingKey {
    case id, time, content, user, imageUrls
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let timeString = try container.decode(String.self, forKey: .time)
    id = try container.decode(Int64.self, forKey: .id)
    time = ISO8601DateFormatter().date(from: timeString) ?? Date()
    content = try container.decode(String.self, forKey: .content)
    user = try container.decode(UserDto.self, forKey: .user)
    imageUrls = try container.decode([String].self, forKey: .imageUrls)
  }
}
