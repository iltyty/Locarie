//
//  user.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation
import MapKit
import SwiftUI

final class User: Hashable, Equatable, Identifiable, Codable, ObservableObject {
    var id = 0.0
    @Published var type = UserType.plain
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var avatarUrl = ""

    // the following fields are only valid for business users
    @Published var coverUrl = ""
    @Published var introduction = ""
    @Published var category = ""
    @Published var homepageUrl = ""
    @Published var phone = ""
    @Published var openTime = DateComponents()
    @Published var closeTime = DateComponents()
    @Published var location = CLLocation()
    @Published var locationName = ""

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Double.self, forKey: .id)
        type = try UserType(rawValue: container.decode(String.self, forKey: .type)) ?? .plain
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        coverUrl = try container.decodeIfPresent(String.self, forKey: .coverUrl) ?? ""
        introduction = try container.decodeIfPresent(String.self, forKey: .introduction) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        homepageUrl = try container.decodeIfPresent(String.self, forKey: .homepageUrl) ?? ""

        let openTimeHour = try container.decodeIfPresent(Int.self, forKey: .openTimeHour) ?? 0
        let openTimeMinute = try container.decodeIfPresent(Int.self, forKey: .openTimeMinute) ?? 0
        let closeTimeHour = try container.decodeIfPresent(Int.self, forKey: .closeTimeHour) ?? 0
        let closeTimeMinute = try container.decodeIfPresent(Int.self, forKey: .closeTimeMinute) ?? 0
        openTime = DateComponents()
        openTime.hour = openTimeHour
        openTime.minute = openTimeMinute
        closeTime = DateComponents()
        closeTime.hour = closeTimeHour
        closeTime.minute = closeTimeMinute

        let locationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        let latitude = try locationContainer.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        let longitude = try locationContainer.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        location = CLLocation(latitude: latitude, longitude: longitude)
        locationName = try container.decode(String.self, forKey: .locationName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(coverURL, forKey: .coverUrl)
        try container.encode(introduction, forKey: .introduction)
        try container.encode(category, forKey: .category)
        try container.encode(homepageUrl, forKey: .homepageUrl)
        try container.encode(phone, forKey: .phone)
        try container.encode(openTime.hour, forKey: .openTimeHour)
        try container.encode(openTime.minute, forKey: .openTimeMinute)
        try container.encode(closeTime.hour, forKey: .closeTimeHour)
        try container.encode(closeTime.minute, forKey: .closeTimeMinute)
        try container.encode(locationName, forKey: .locationName)

        var locationContainer = container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        try locationContainer.encode(location.coordinate.latitude, forKey: .latitude)
        try locationContainer.encode(location.coordinate.longitude, forKey: .longitude)
    }

    var avatar: Image {
        Image(avatarUrl) // TODO: load image from url
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

    enum CodingKeys: String, CodingKey {
        case id, type, username, email, password, avatarUrl, coverUrl, introduction,
             category, phone, homepageUrl, openTimeHour, openTimeMinute,
             closeTimeHour, closeTimeMinute, location, locationName
    }

    enum LocationKeys: String, CodingKey {
        case latitude, longitude
    }

    enum UserType: String, CaseIterable, Identifiable {
        case plain = "PLAIN"
        case business = "BUSINESS"
        var id: Self { self }
    }
}

extension User {
    static let user1 = UserViewModel.getUserById(1)!
    static let business1 = UserViewModel.getUserById(2)!
    static let business2 = UserViewModel.getUserById(3)!
}
