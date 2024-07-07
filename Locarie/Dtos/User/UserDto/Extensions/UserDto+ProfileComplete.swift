//
//  UserDto+ProfileComplete.swift
//  locarie
//
//  Created by qiuty on 24/06/2024.
//

extension UserDto {
  var isProfileComplete: Bool {
    !(
      profileImageUrls.isEmpty ||
        avatarUrl.isEmpty ||
        businessName.isEmpty ||
        username.isEmpty ||
        categories.isEmpty ||
        introduction.isEmpty ||
        location == nil ||
        businessHours.isEmpty
    )
  }
}
