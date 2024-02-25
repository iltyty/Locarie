//
//  BusinessNameAvatarUrlDto.swift
//  locarie
//
//  Created by qiuty on 25/02/2024.
//

struct BusinessNameAvatarUrlDto: Codable, Identifiable {
  let id: Int64
  let avatarUrl: String?
  let businessName: String
}
