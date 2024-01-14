//
//  ProfileGetService.swift
//  locarie
//
//  Created by qiuty on 08/01/2024.
//

import Alamofire
import Combine
import Foundation

protocol ProfileGetService {
  func getUserProfile(id: Int64) -> AnyPublisher<ProfileGetResponse, Never>
}

final class ProfileGetServiceImpl: BaseAPIService, ProfileGetService {
  static let shared = ProfileGetServiceImpl()
  override private init() {}

  func getUserProfile(id: Int64) -> AnyPublisher<ProfileGetResponse, Never> {
    let endpoint = APIEndpoints.userProfileUrl(id: id)
    return AF.request(endpoint, method: .get)
      .validate()
      .publishDecodable(type: ResponseDto<UserDto>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias ProfileGetResponse = DataResponse<ResponseDto<UserDto>, NetworkError>
