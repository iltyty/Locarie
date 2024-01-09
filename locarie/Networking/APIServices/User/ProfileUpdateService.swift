//
//  ProfileUpdateService.swift
//  locarie
//
//  Created by qiuty on 08/01/2024.
//

import Alamofire
import Combine
import Foundation

protocol ProfileUpdateService {
  func updateProfile(id: Int64, data dto: UserDto) ->
    AnyPublisher<ProfileGetResponse, Never>
}

final class ProfileUpdateServiceImpl: BaseAPIService, ProfileUpdateService {
  static let shared = ProfileUpdateServiceImpl()
  override private init() {}

  func updateProfile(
    id: Int64,
    data dto: UserDto
  ) -> AnyPublisher<ProfileUpdateResponse, Never> {
    let endpoint = APIEndpoints.userUpdateProfileUrl(id: id)
    return AF.request(
      endpoint,
      method: .post,
      parameters: dto,
      encoder: JSONParameterEncoder.default
    )
    .validate()
    .publishDecodable(type: ResponseDto<UserDto>.self)
    .map { self.mapResponse($0) }
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
  }
}

typealias ProfileUpdateResponse = DataResponse<
  ResponseDto<UserDto>, NetworkError
>
