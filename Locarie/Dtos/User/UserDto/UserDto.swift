//
//  UserDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import CoreLocation
import Foundation

struct UserDto: Codable, Equatable, Identifiable, UserInfo, UserLocation {
  static func == (lhs: UserDto, rhs: UserDto) -> Bool {
    lhs.id == rhs.id
  }

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

  var lastUpdate: Date?

  var businessHours = [BusinessHoursDto]()

  var favoredByCount: Int = 0
  var favoritePostsCount: Int = 0
  var favoriteBusinessesCount: Int = 0

  mutating func trimStringFields() {
    email = email.trimmingCharacters(in: .whitespacesAndNewlines)
    firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
    lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
    username = username.trimmingCharacters(in: .whitespacesAndNewlines)
    businessName = businessName.trimmingCharacters(in: .whitespacesAndNewlines)
    homepageUrl = homepageUrl.trimmingCharacters(in: .whitespacesAndNewlines)
    introduction = introduction.trimmingCharacters(in: .whitespacesAndNewlines)
    phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
    address = address.trimmingCharacters(in: .whitespacesAndNewlines)
    neighborhood = neighborhood.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

enum UserType: String, Codable {
  case regular = "PLAIN"
  case business = "BUSINESS"
}

struct BusinessLocation: Codable, Equatable {
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
  func distance(to location: CLLocation?) -> String {
    let cacheVM = LocalCacheViewModel.shared
    guard let location else {
      if cacheVM.isCurrentMilesDistanceUnits() {
        return "0 mi"
      }
      return "0 km"
    }
    let dist = location.distance(from: clLocation)
    if cacheVM.isCurrentMilesDistanceUnits() {
      let feet = dist * 3.28084
      let miles = dist / 1609.34
      return feet < 1000 ? String(format: "%.f ft", feet) : String(format: "%.f mi", miles)
    }
    return dist < 1000 ? String(format: "%.f m", dist) : String(format: "%.f km", dist / 1000)
  }

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
  var lastUpdateTime: String { lastUpdate?.timeAgoString() ?? "" }

  var hasUpdateIn24Hours: Bool {
    if let lastUpdate, Date.now.timeIntervalSince(lastUpdate) < 86400 {
      return true
    }
    return false
  }

  var openUtil: String {
    guard businessHours.count == 7 else { return "Closed" }
    guard let todayBusinessHours else { return "Closed" }
    if isNowClosed {
      return "Closed"
    }
    return "until \(todayBusinessHours.formattedClosingTime)"
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
    for i in 0 ..< todayBusinessHours.openingHoursCount {
      let openingTime = Calendar.current.date(
        bySettingHour: todayBusinessHours.openingTime[i].hour ?? 0,
        minute: todayBusinessHours.openingTime[i].minute ?? 0,
        second: 0,
        of: now
      )!
      let closingTime = Calendar.current.date(
        bySettingHour: todayBusinessHours.closingTime[i].hour ?? 0,
        minute: todayBusinessHours.closingTime[i].minute ?? 0,
        second: 0,
        of: now
      )!
      if now >= openingTime, now <= closingTime {
        return true
      }
    }
    return false
  }
}

extension UserDto {
  enum CodingKeys: String, CodingKey {
    case id, type, email, firstName, lastName, username, avatarUrl, birthday
    case businessName, categories, profileImageUrls, homepageUrl, introduction,
         phone
    case address, neighborhood, location, businessHours, lastUpdate
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
    if try container.decodeNil(forKey: .lastUpdate) {
      lastUpdate = nil
    } else {
      let lastUpdateTimestamp = try container.decode(Int64.self, forKey: .lastUpdate)
      lastUpdate = .init(timeIntervalSince1970: Double(lastUpdateTimestamp) / 1000)
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
