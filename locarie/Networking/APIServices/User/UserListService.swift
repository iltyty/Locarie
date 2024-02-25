//
//  UserListService.swift
//  locarie
//
//  Created by qiuty on 25/02/2024.
//

import Alamofire
import Combine
import Foundation

protocol UserListService {
  func listBusinesses() -> AnyPublisher<ListBusinessesResponse, Never>
}

final class UserListServiceImpl: BaseAPIService, UserListService {
  static let shared = UserListServiceImpl()
  override private init() {}

  func listBusinesses() -> AnyPublisher<ListBusinessesResponse, Never> {
    AF.request(APIEndpoints.listBusinessesUrl, method: .get)
      .validate()
      .publishDecodable(type: ResponseDto<[BusinessNameAvatarUrlDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias ListBusinessesResponse = DataResponse<
  ResponseDto<[BusinessNameAvatarUrlDto]>,
  NetworkError
>
