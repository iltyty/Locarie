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

extension UserDto {
  enum CodingKeys: String, CodingKey {
    case id, type, email, firstName, lastName, username, avatarUrl
    case category, coverUrl, homepageUrl, introduction, phone
    case openHour, openMinute, closeHour, closeMinute
    case address, location
  }

  enum LocationCodingKeys: String, CodingKey {
    case latitude, longitude
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let typeRawValue = try container.decode(String.self, forKey: .type)
    type = UserType(rawValue: typeRawValue) ?? .regular

    id = try container.decode(Int64.self, forKey: .id)
    email = try container.decode(String.self, forKey: .email)
    firstName = try container.decode(String.self, forKey: .firstName)
    lastName = try container.decode(String.self, forKey: .lastName)
    username = try container.decode(String.self, forKey: .username)
    avatarUrl = decodeWithDefault(container, forKey: .avatarUrl)

    category = decodeWithDefault(container, forKey: .category)
    coverUrl = decodeWithDefault(container, forKey: .coverUrl)
    homepageUrl = decodeWithDefault(container, forKey: .homepageUrl)
    introduction = decodeWithDefault(container, forKey: .introduction)
    phone = decodeWithDefault(container, forKey: .phone)

    openHour = decodeWithDefault(container, forKey: .openHour)
    openMinute = decodeWithDefault(container, forKey: .openMinute)
    closeHour = decodeWithDefault(container, forKey: .closeHour)
    closeMinute = decodeWithDefault(container, forKey: .closeMinute)

    address = decodeWithDefault(container, forKey: .address)
    if try container.decodeNil(forKey: .location) {
      location = BusinessLocation(latitude: 0, longitude: 0)
    } else {
      let locationContainer = try container.nestedContainer(
        keyedBy: LocationCodingKeys.self,
        forKey: .location
      )
      location = BusinessLocation(
        latitude: decodeWithDefault(locationContainer, forKey: .latitude),
        longitude: decodeWithDefault(locationContainer, forKey: .longitude)
      )
    }
  }
}

private func decodeWithDefault<K: CodingKey>(
  _ container: KeyedDecodingContainer<K>,
  forKey key: KeyedDecodingContainer<K>.Key,
  default value: String = ""
) -> String {
  let result = try? container.decodeIfPresent(String.self, forKey: key)
  return result ?? value
}

private func decodeWithDefault<K: CodingKey>(
  _ container: KeyedDecodingContainer<K>,
  forKey key: KeyedDecodingContainer<K>.Key,
  default value: Int = 0
) -> Int {
  let result = try? container.decodeIfPresent(Int.self, forKey: key)
  return result ?? value
}

private func decodeWithDefault<K: CodingKey>(
  _ container: KeyedDecodingContainer<K>,
  forKey key: KeyedDecodingContainer<K>.Key,
  default value: Double = 0
) -> Double {
  let result = try? container.decodeIfPresent(Double.self, forKey: key)
  return result ?? value
}
