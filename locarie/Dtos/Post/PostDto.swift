//
//  PostDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import CoreLocation
import Foundation

struct PostDto: Codable, Identifiable, Equatable {
  var id: Int64 = 0
  var time = Date()
  var content = ""
  var favoredByCount = 0
  var user = UserDto()
  var imageUrls: [String] = []

  static func == (lhs: PostDto, rhs: PostDto) -> Bool {
    lhs.id == rhs.id
  }
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
    case id, time, content, favoredByCount, user, imageUrls
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int64.self, forKey: .id)
    let timestamp = try container.decode(Int64.self, forKey: .time)
    time = timestamp == 0 ? Date() : Date(timeIntervalSince1970: Double(timestamp) / 1000)
    content = try container.decode(String.self, forKey: .content)
    favoredByCount = try container.decode(Int.self, forKey: .favoredByCount)
    user = try container.decode(UserDto.self, forKey: .user)
    imageUrls = try container.decode([String].self, forKey: .imageUrls)
  }
}

extension PostDto {
  var publishedOneDayAgo: Bool {
    Date().timeIntervalSince(time) / 3600 > 24
  }

  var publishedTime: String { time.timeAgoString() }
}
