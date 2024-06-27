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

struct LoginResponseDto: Codable, UserCache {
  let id: Int64
  let email: String
  let type: UserType
  let username: String
  let avatarUrl: String
  let jwtToken: String

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int64.self, forKey: .id)
    email = try container.decode(String.self, forKey: .email)
    type = try container.decode(UserType.self, forKey: .type)
    username = try container.decode(String.self, forKey: .username)
    avatarUrl = try container
      .decodeIfPresent(String.self, forKey: .avatarUrl) ?? ""
    jwtToken = try container.decode(String.self, forKey: .jwtToken)
  }
}
