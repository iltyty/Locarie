//
//  UserLoginDto.swift
//  locarie
//
//  Created by qiuty on 16/12/2023.
//

import Foundation

struct LoginRequestDto: Codable {
  var email: String
  var password: String
}

struct LoginResponseDto: Codable, UserInfo {
  let id: Double
  let type: String
  let username: String
  let avatarUrl: String?
  let jwtToken: String
}
