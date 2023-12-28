//
//  UserLoginService.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Alamofire
import Combine
import Foundation

protocol LoginService {
  func login(dto: LoginRequestDto) -> AnyPublisher<LoginResponse, Never>
}

final class LoginServiceImpl: BaseAPIService, LoginService {
  static let shared = LoginServiceImpl()
  override private init() {}

  func login(dto: LoginRequestDto) -> AnyPublisher<LoginResponse, Never> {
    let parameters = prepareParameters(withData: dto)
    return AF.request(
      APIEndpoints.userLoginUrl,
      method: .post,
      parameters: parameters
    )
    .validate()
    .publishDecodable(type: ResponseDto<LoginResponseDto>.self)
    .map { self.mapResponse($0) }
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
  }
}

typealias LoginResponse = DataResponse<
  ResponseDto<LoginResponseDto>,
  NetworkError
>
