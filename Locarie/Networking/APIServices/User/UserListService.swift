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
  func listBusinesses(latitude: Double, longitude: Double, name: String, page: Int, size: Int) -> AnyPublisher<ListBusinessesResponse, Never>
  func listAllBusinesses() -> AnyPublisher<ListAllBusinessesResponse, Never>
}

final class UserListServiceImpl: BaseAPIService, UserListService {
  static let shared = UserListServiceImpl()
  override private init() {}

  func listBusinesses(latitude: Double, longitude: Double, name: String, page: Int, size: Int) -> AnyPublisher<ListBusinessesResponse, Never> {
    let params = [
      "latitude": latitude,
      "longitude": longitude,
      "page": page,
      "size": size,
      "name": name
    ] as [String : Any]
    return AF.request(APIEndpoints.listBusinessesUrl, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: PaginatedResponseDto<UserDto>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func listAllBusinesses() -> AnyPublisher<ListAllBusinessesResponse, Never> {
    AF.request(APIEndpoints.listAllBusinessesUrl, method: .get)
      .validate()
      .publishDecodable(type: ResponseDto<[UserLocationDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias ListBusinessesResponse = DataResponse<PaginatedResponseDto<UserDto>, NetworkError>
typealias ListAllBusinessesResponse = DataResponse<ResponseDto<[UserLocationDto]>, NetworkError>
