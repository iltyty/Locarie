//
//  PostCreateDto.swift
//  locarie
//
//  Created by qiuty on 16/12/2023.
//

import Foundation

struct PostCreateRequestDto: Codable {
    var user: UserId
    var title: String
    var content: String
}

struct PostCreateResponseDto: Codable {
    let id: Int64
    let title: String
    let content: String
}

struct UserId: Codable {
    let id: Double
}
