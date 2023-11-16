//
//  user.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation
import SwiftUI
import MapKit

struct User: Hashable, Equatable, Identifiable, Decodable {
    
    var id = 0
    var username = ""
    var avatarUrl = ""
    
    // the following fields are only valid for business users
    var coverUrl = ""
    var introduction = ""
    var category = ""
    var homepageUrl = ""
    var phone = ""
    var openTime = DateComponents()
    var closeTime = DateComponents()
    var location = CLLocation()
    var locationName = ""
    
    enum CodingKeys: String, CodingKey {
        case id, username, avatarUrl, coverUrl, introduction,
            category, phone, homepageUrl, openTimeHour, openTimeMinute,
            closeTimeHour, closeTimeMinute, location, locationName
    }
    
    enum LocationKeys: String, CodingKey {
        case latitude, longitude
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        coverUrl = try container.decode(String.self, forKey: .coverUrl)
        introduction = try container.decode(String.self, forKey: .introduction)
        category = try container.decode(String.self, forKey: .category)
        phone = try container.decode(String.self, forKey: .phone)
        
        homepageUrl = try container.decode(String.self, forKey: .homepageUrl)
        let openTimeHour = try container.decode(Int.self, forKey: .openTimeHour)
        let openTimeMinute = try container.decode(Int.self, forKey: .openTimeMinute)
        let closeTimeHour = try container.decode(Int.self, forKey: .closeTimeHour)
        let closeTimeMinute = try container.decode(Int.self, forKey: .closeTimeMinute)
        openTime = DateComponents()
        openTime.hour = openTimeHour
        openTime.minute = openTimeMinute
        closeTime = DateComponents()
        closeTime.hour = closeTimeHour
        closeTime.minute = closeTimeMinute
        
        let locationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        let latitude = try locationContainer.decode(Double.self, forKey: .latitude)
        let longitude = try locationContainer.decode(Double.self, forKey: .longitude)
        location = CLLocation(latitude: latitude, longitude: longitude)
        
        locationName = try container.decode(String.self, forKey: .locationName)
    }
    
    var avatar: Image {
        Image(avatarUrl)  // TODO: load image from url
    }
    
    var avatarURL: URL? {
        URL(string: avatarUrl)
    }
    
    var coverURL: URL? {
        URL(string: coverUrl)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension User {
    static let user1 = UserViewModel.getUserById(1)!
    static let business1 = UserViewModel.getUserById(2)!
    static let business2 = UserViewModel.getUserById(3)!
}
