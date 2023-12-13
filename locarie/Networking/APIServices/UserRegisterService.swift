//
//  UserRegisterService.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Alamofire
import Foundation

extension APIServices {
    static func register(user: User) async throws -> ResponseDto<User> {
        do {
            let data = try prepareMultipartFormData(user: user)
            return try await sendRegisterRequest(multipartFormData: data)
        } catch {
            try handleRegisterError(error)
        }
        throw LError.cannotReach
    }

    private static func prepareMultipartFormData(user: User) throws -> MultipartFormData {
        let result = MultipartFormData()
        let userData = try JSONEncoder().encode(user)
        result.append(userData, withName: "user", mimeType: "application/json")
        return result
    }

    private static func sendRegisterRequest(multipartFormData data: MultipartFormData) async throws -> ResponseDto<User> {
        try await AF
            .upload(multipartFormData: data, to: APIEndpoints.userRegisterUrl)
            .serializingDecodable(ResponseDto<User>.self)
            .value
    }

    private static func handleRegisterError(_ error: Error) throws {
        try handleError(error)
    }
}
