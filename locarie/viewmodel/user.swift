//
//  user.swift
//  locarie
//
//  Created by qiuty on 2023/11/8.
//

import Foundation
import SwiftUI
import MapKit

struct User: Hashable, Equatable, Identifiable {
    
    var id: Int
    var username: String
    var avatarName: String  // TODO: switch to url based avatar
    
    // the following fields are only valid for business users
    var coverName = ""  // TODO: switch to url based cover
    var openTime = DateComponents()
    var closeTime = DateComponents()
    var location = CLLocation()
    var locationName = ""
    
    init() {
        id = 1
        username = "Jolene Hornsey"
        avatarName = "avatar"
    }
    
    init(id: Int, username: String, avatarName: String) {
        self.id = id
        self.username = username
        self.avatarName = avatarName
    }
    
    init(id: Int, username: String, avatarName: String, coverName: String, openTime: DateComponents,
         closeTime: DateComponents, location: CLLocation, locationName: String) {
        self.init(id: id, username: username, avatarName: avatarName)
        self.coverName = coverName
        if let hour = openTime.hour, let minute = openTime.minute {
            self.openTime.hour = hour
            self.openTime.minute = minute
        }
        if let hour = closeTime.hour, let minute = closeTime.minute {
            self.closeTime.hour = hour
            self.closeTime.minute = minute
        }
        self.location = location
        self.locationName = locationName
    }
    
    init(id: Int, username: String, avatarName: String, coverName: String, openTime: DateComponents,
         closeTime: DateComponents, latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationName: String) {
        self.init(id: id, username: username, avatarName: avatarName, coverName: coverName, openTime: openTime, closeTime: closeTime,
                  location: CLLocation(latitude: latitude, longitude: longitude), locationName: locationName)
    }
    
    var avatar: Image {
        Image(avatarName)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension User {
    static let user1 = UserViewModel.getUserById(1)
    static let business1 = UserViewModel.getUserById(2)
    static let business2 = UserViewModel.getUserById(3)
}
