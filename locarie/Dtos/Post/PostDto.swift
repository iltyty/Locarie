//
//  PostDto.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Foundation

struct PostDto: Codable {
  let id: Int64
  let time: Date
  let title: String
  let content: String
  let user: UserDto

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int64.self, forKey: .id)
    time = try container.decode(Date.self, forKey: .time)
    title = try container.decode(String.self, forKey: .title)
    content = try container.decode(String.self, forKey: .content)
    user = try container.decode(UserDto.self, forKey: .user)
  }
}
