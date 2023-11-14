//
//  post.swift
//  locarie
//
//  Created by qiuty on 2023/11/11.
//

import Foundation
import MapKit
import SwiftUI

struct Post: Identifiable {
    let id: String
    let uid: Int  // business user's id
    var title: String
    var content: String
    var time: Date
    var imageNames: [String]  // TODO: switch to URL based images
    
    init(uid: Int, title: String, content: String, time: Date, imageNames: [String]) {
        self.uid = uid
        self.id = UUID().uuidString
        self.time = time
        self.title = title
        self.content = content
        self.imageNames = imageNames
    }
}

extension Post {
    var businessUser: User {
        UserViewModel.getUserById(uid)
    }
    
    var businessName: String {
        businessUser.username
    }
    
    var businessAvatarName: String {
        businessUser.avatarName
    }
    
    var businessAvatar: Image {
        Image(businessAvatarName)
    }
    
    var businessLocation: CLLocation {
        businessUser.location
    }
    
    var businessLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: businessLocation.coordinate.latitude, longitude: businessLocation.coordinate.longitude)
    }
    
    var businessLocationName: String {
        businessUser.locationName
    }
    
    var businessOpenTime: DateComponents {
        businessUser.openTime
    }
    
    var businessCloseTime: DateComponents {
        businessUser.closeTime
    }
}
