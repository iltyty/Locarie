//
//  UserDeleteService.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Alamofire
import Combine
import Foundation

protocol UserDeleteService {
  func delete(id: Int64) -> AnyPublisher<UserDeleteResponse, Never>
}

final class UserDeleteServiceImpl: BaseAPIService, UserDeleteService {
  static let shared = UserDeleteServiceImpl()
  override private init() {}

  func delete(id: Int64) -> AnyPublisher<UserDeleteResponse, Never> {
    let endpoint = APIEndpoints.userUrl(id: id)
    return AF.request(endpoint, method: .delete)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias UserDeleteResponse = DataResponse<ResponseDto<Bool>, NetworkError>
