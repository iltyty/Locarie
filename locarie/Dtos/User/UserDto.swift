//
//  UserDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import CoreLocation
import Foundation

struct UserDto: Codable, Identifiable, UserInfo, UserLocation {
  var id: Int64 = 0
  var type: UserType = .regular
  var email: String = ""
  var firstName: String = ""
  var lastName: String = ""
  var username: String = ""
  var avatarUrl: String = ""
  var birthday: Date?

  var businessName: String = ""
  var categories: [String] = []
  var profileImageUrls: [String] = []
  var homepageUrl: String = ""
  var introduction: String = ""
  var phone: String = ""

  var address: String = ""
  var neighborhood: String = ""
  var location: BusinessLocation?

  var businessHours = [BusinessHoursDto]()

  var favoredByCount: Int = 0
  var favoritePostsCount: Int = 0
  var favoriteBusinessesCount: Int = 0
}

enum UserType: String, Codable {
  case regular = "PLAIN"
  case business = "BUSINESS"
}

struct BusinessLocation: Codable {
  var latitude: Double = .nan
  var longitude: Double = .nan

  var isValid: Bool {
    !latitude.isNaN && !longitude.isNaN
  }
}

extension UserDto {
  var formattedBirthday: String {
    guard let birthday else { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: birthday)
  }

  var formattedBusinessHours: String {
    get { businessHours.map(\.formattedStatus).joined(separator: ", ") }
    set {}
  }
}

extension UserDto {
  var clLocation: CLLocation {
    .init(
      latitude: location?.latitude ?? .nan,
      longitude: location?.longitude ?? .nan
    )
  }

  var coordinate: CLLocationCoordinate2D {
    if let location {
      .init(
        latitude: location.latitude,
        longitude: location.longitude
      )
    } else {
      .london
    }
  }
}

extension UserDto {
  var openUtil: String {
    guard businessHours.count == 7 else { return "Closed" }
    guard let todayBusinessHours else { return "Closed" }
    if isNowClosed {
      return "Closed"
    }
    return "Open util \(todayBusinessHours.formattedClosingTime)"
  }

  private var todayBusinessHours: BusinessHoursDto? {
    businessHours.first { $0.dayOfWeek == dayOfWeek }
  }

  private var dayOfWeek: BusinessHoursDto.DayOfWeek {
    let index = Calendar.current.component(.weekday, from: Date()) - 1
    return BusinessHoursDto.DayOfWeek.allCases[index]
  }

  var isNowClosed: Bool {
    guard let todayBusinessHours else { return true }
    if todayBusinessHours.closed { return true }
    let now = Date()
    let closingTime = todayBusinessHours.closingTime
    let closingDate = Calendar.current.date(
      bySettingHour: closingTime.hour ?? 0,
      minute: closingTime.minute ?? 0,
      second: 0,
      of: now
    )!
    return now > closingDate
  }
}

extension UserDto {
  enum CodingKeys: String, CodingKey {
    case id, type, email, firstName, lastName, username, avatarUrl, birthday
    case businessName, categories, profileImageUrls, homepageUrl, introduction,
         phone
    case address, neighborhood, location, businessHours
    case favoredByCount, favoritePostsCount, favoriteBusinessesCount
  }

  enum LocationCodingKeys: String, CodingKey {
    case latitude, longitude
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try container.decode(Int64.self, forKey: .id)
    let typeRawValue = try container.decode(String.self, forKey: .type)
    type = UserType(rawValue: typeRawValue) ?? .regular

    email = try container.decode(String.self, forKey: .email)
    firstName = try container.decode(String.self, forKey: .firstName)
    lastName = try container.decode(String.self, forKey: .lastName)
    username = try container.decode(String.self, forKey: .username)
    avatarUrl = decodeWithDefault(container, forKey: .avatarUrl)
    let birthdayString = try container.decodeIfPresent(
      String.self,
      forKey: .birthday
    )
    if let birthdayString {
      birthday = ISO8601DateFormatter().date(from: birthdayString)
    }

    businessName = decodeWithDefault(container, forKey: .businessName)
    categories = decodeWithDefault(container, forKey: .categories)
    profileImageUrls = decodeWithDefault(container, forKey: .profileImageUrls)
    homepageUrl = decodeWithDefault(container, forKey: .homepageUrl)
    introduction = decodeWithDefault(container, forKey: .introduction)
    phone = decodeWithDefault(container, forKey: .phone)

    address = decodeWithDefault(container, forKey: .address)
    neighborhood = decodeWithDefault(container, forKey: .neighborhood)
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
    if try container.decodeNil(forKey: .businessHours) {
      businessHours = []
    } else {
      businessHours = try container.decode(
        [BusinessHoursDto].self, forKey: .businessHours
      )
    }

    favoredByCount = try container.decode(Int.self, forKey: .favoredByCount)
    favoritePostsCount = try container.decode(
      Int.self, forKey: .favoritePostsCount
    )
    favoriteBusinessesCount = try container.decode(
      Int.self, forKey: .favoriteBusinessesCount
    )
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

private func decodeWithDefault<K: CodingKey>(
  _ container: KeyedDecodingContainer<K>,
  forKey key: KeyedDecodingContainer<K>.Key,
  default value: [String] = []
) -> [String] {
  let result = try? container.decodeIfPresent([String].self, forKey: key)
  return result ?? value
}

private func decodeWithDefault<K: CodingKey>(
  _ container: KeyedDecodingContainer<K>,
  forKey key: KeyedDecodingContainer<K>.Key,
  default value: Date = Date()
) -> Date {
  let result = try? container.decodeIfPresent(Date.self, forKey: key)
  return result ?? value
}
