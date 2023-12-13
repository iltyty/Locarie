//
//  Dtos.swift
//  locarie
//
//  Created by qiuty on 10/12/2023.
//

import Foundation

struct ResponseDto<T: Decodable>: Decodable {
    let status: Int
    let message: String
    let data: T?
}

struct UserLoginRequestDto: Codable {
    let email: String
    let password: String
}

struct UserLoginResponse: Codable, UserInfo {
    let id: Double
    let username: String
    let jwtToken: String
}

func structToDict<T: Codable>(data: T) throws -> [String: Any]? {
    let jsonData = try JSONEncoder().encode(data)
    return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
}
