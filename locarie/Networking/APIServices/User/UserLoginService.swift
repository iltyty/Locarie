//
//  UserLoginService.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Alamofire

extension APIServices {
  static func login(dto: LoginRequestDto) async throws
    -> ResponseDto<LoginResponseDto>
  {
    do {
      let parameters = try structToDict(data: dto)
      return try await sendLoginRequest(parameters: parameters)
    } catch {
      try handleLoginError(error)
    }
    throw LError.cannotReach
  }

  private static func sendLoginRequest(parameters: Parameters?) async throws
    -> ResponseDto<LoginResponseDto>
  {
    try await AF
      .request(
        APIEndpoints.userLoginUrl,
        method: .post,
        parameters: parameters
      )
      .serializingDecodable(ResponseDto<LoginResponseDto>.self)
      .value
  }

  private static func handleLoginError(_ error: Error) throws {
    try handleError(error)
  }
}
