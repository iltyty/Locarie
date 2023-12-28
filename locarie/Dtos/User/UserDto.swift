//
//  UserDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Foundation

struct UserDto: Codable {
  let id: Int64
  let type: UserType
  let email: String
  let firstName: String
  let lastName: String
  let username: String
  let avatarUrl: String

  let category: String
  let coverUrl: String
  let homepageUrl: String
  let introduction: String
  let phone: String

  let openHour: Int
  let openMinute: Int
  let closeHour: Int
  let closeMinute: Int

  let address: String
  let location: BusinessLocation
}

enum UserType: String, Codable {
  case regular = "PLAIN"
  case business = "BUSINESS"
}

struct BusinessLocation: Codable {
  var latitude: Double = 0
  var longitude: Double = 0
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
