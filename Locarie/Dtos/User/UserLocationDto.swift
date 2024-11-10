//
//  UserLocationDto.swift
//  Locarie
//
//  Created by qiu on 2024/11/10.
//

import Foundation

struct UserLocationDto: Codable, Equatable, Identifiable {
  var id: Int64 = 0
  var avatarUrl: String
  var location: BusinessLocation
  var lastUpdate: Date?
  
  var hasUpdateIn24Hours: Bool {
    if let lastUpdate, Date.now.timeIntervalSince(lastUpdate) < 86400 {
      return true
    }
    return false
  }
}

extension UserLocationDto {
  enum CodingKeys: String, CodingKey {
    case id, avatarUrl, location, lastUpdate
  }
  
  enum LocationCodingKeys: String, CodingKey {
    case latitude, longitude
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(Int64.self, forKey: .id)
    avatarUrl = decodeWithDefault(container, forKey: .avatarUrl)
    
    if try container.decodeNil(forKey: .lastUpdate) {
      lastUpdate = nil
    } else {
      let lastUpdateTimestamp = try container.decode(Int64.self, forKey: .lastUpdate)
      lastUpdate = .init(timeIntervalSince1970: Double(lastUpdateTimestamp) / 1000)
    }
    
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
