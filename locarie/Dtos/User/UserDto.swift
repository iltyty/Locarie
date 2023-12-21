//
//  UserDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Foundation

struct UserDto: Codable {
  let id: Int64
  let type: String
  let username: String
  let avatarUrl: String

  // the following fields are only valid for business users
  let category: String
  let coverUrl: String
  let homepageUrl: String
  let introduction: String
  let phone: String

  let openHour: Int
  let openMinute: Int
  let closeHour: Int
  let closeMinute: Int

  let location: Location
  let locationName: String
}

extension UserDto {
  var openTime: DateComponents {
    var dateComponents = DateComponents()
    dateComponents.hour = openHour
    dateComponents.minute = openMinute
    return dateComponents
  }

  var closeTime: DateComponents {
    var dateComponents = DateComponents()
    dateComponents.hour = closeHour
    dateComponents.minute = closeMinute
    return dateComponents
  }
}

struct Location: Codable {
  let latitude: Double
  let longitude: Double
}
