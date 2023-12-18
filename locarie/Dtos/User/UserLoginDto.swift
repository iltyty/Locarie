//
//  UserLoginDto.swift
//  locarie
//
//  Created by qiuty on 16/12/2023.
//

import Foundation

struct UserLoginRequestDto: Codable {
  let email: String
  let password: String
}

struct UserLoginResponse: Codable, UserInfo {
  let id: Double
  let type: String
  let username: String
  let avatarUrl: String
  let jwtToken: String
}
