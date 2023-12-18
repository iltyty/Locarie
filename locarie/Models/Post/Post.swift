//
//  Post.swift
//  locarie
//
//  Created by qiuty on 2023/11/11.
//

import Foundation
import MapKit
import SwiftUI

struct Post: Identifiable, Decodable {
  let id: String
  let uid: Double // business user's id
  var title: String
  var content: String
  var time: Date
  var imageUrls: [String]

  init(
    uid: Double,
    title: String,
    content: String,
    time: Date,
    imageUrls: [String]
  ) {
    self.uid = uid
    id = UUID().uuidString
    self.time = time
    self.title = title
    self.content = content
    self.imageUrls = imageUrls
  }
}

extension Post {
  var businessUser: User {
    UserViewModel.getUserById(uid) ?? User()
  }

  var businessName: String {
    businessUser.username
  }

  var businessAvatarUrl: String {
    businessUser.avatarUrl
  }

  var businessLocation: CLLocation {
    businessUser.location
  }

  var businessLocationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: businessLocation.coordinate.latitude,
      longitude: businessLocation.coordinate.longitude
    )
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
