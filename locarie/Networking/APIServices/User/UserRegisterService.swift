//
//  UserRegisterService.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Alamofire
import Combine
import Foundation

protocol UserRegisterService {
  func register(user: RegisterRequestDto)
    -> AnyPublisher<RegisterResponse, Never>
}

final class UserRegisterServiceImpl: BaseAPIService, UserRegisterService {
  static let shared = UserRegisterServiceImpl()
  override private init() {}

  func register(user: RegisterRequestDto)
    -> AnyPublisher<RegisterResponse, Never>
  {
    let parameters = prepareParameters(withData: user)
    return AF.request(
      APIEndpoints.userRegisterUrl,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
    .validate()
    .publishDecodable(type: ResponseDto<UserDto>.self)
    .map { self.mapResponse($0) }
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
  }
}

typealias RegisterResponse = DataResponse<ResponseDto<UserDto>, NetworkError>
