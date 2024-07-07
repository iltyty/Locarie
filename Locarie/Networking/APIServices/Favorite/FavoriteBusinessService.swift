//
//  FavoriteBusinessService.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import Alamofire
import Combine
import Foundation

protocol FavoriteBusinessService {
  func favorite(userId: Int64, businessId: Int64)
    -> AnyPublisher<FavoriteBusinessResponse, Never>
  func unfavorite(userId: Int64, businessId: Int64)
    -> AnyPublisher<UnfavoriteBusinessResponse, Never>
  func list(userId: Int64)
    -> AnyPublisher<ListFavoriteBusinessesResponse, Never>
  func isFavoredBy(userId: Int64, businessId: Int64)
    -> AnyPublisher<BusinessIsFavoredByResponse, Never>
  func listFavoriteBusinessPosts(userId: Int64)
    -> AnyPublisher<ListFavoriteBusinessPostsResponse, Never>
}

final class FavoriteBusinessServiceImpl:
  BaseAPIService, FavoriteBusinessService
{
  static let shared = FavoriteBusinessServiceImpl()
  override private init() {}

  func favorite(userId: Int64, businessId: Int64)
    -> AnyPublisher<FavoriteBusinessResponse, Never>
  {
    let endpoint = APIEndpoints.favoriteBusinessUrl
    let params = prepareIdsParams(userId: userId, businessId: businessId)
    return AF.request(endpoint, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareIdsParams(userId: Int64,
                                businessId: Int64) -> Parameters
  {
    ["userId": "\(userId)", "businessId": "\(businessId)"]
  }

  func unfavorite(userId: Int64, businessId: Int64)
    -> AnyPublisher<UnfavoriteBusinessResponse, Never>
  {
    let endpoint = APIEndpoints.unfavoriteBusinessUrl
    let params = prepareIdsParams(userId: userId, businessId: businessId)
    return AF.request(endpoint, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func list(userId: Int64)
    -> AnyPublisher<ListFavoriteBusinessesResponse, Never>
  {
    let endpoint = APIEndpoints.favoriteBusinessUrl
    let params = prepareUserIdParam(userId: userId)
    return AF.request(endpoint, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<[UserDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareUserIdParam(userId: Int64) -> Parameters {
    ["userId": "\(userId)"]
  }

  func isFavoredBy(userId: Int64, businessId: Int64)
    -> AnyPublisher<BusinessIsFavoredByResponse, Never>
  {
    let endpoint = APIEndpoints.businessIsFavoredByUrl
    let params = prepareIdsParams(userId: userId, businessId: businessId)
    return AF.request(endpoint, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func listFavoriteBusinessPosts(userId: Int64)
    -> AnyPublisher<ListFavoriteBusinessPostsResponse, Never>
  {
    let params = prepareUserIdParam(userId: userId)
    return AF.request(APIEndpoints.listFavoriteBusinessPostsUrl, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias FavoriteBusinessResponse = DataResponse<
  ResponseDto<Bool>, NetworkError
>
typealias UnfavoriteBusinessResponse = DataResponse<
  ResponseDto<Bool>, NetworkError
>
typealias ListFavoriteBusinessesResponse = DataResponse<
  ResponseDto<[UserDto]>, NetworkError
>
typealias BusinessIsFavoredByResponse = DataResponse<
  ResponseDto<Bool>, NetworkError
>
typealias ListFavoriteBusinessPostsResponse = DataResponse<
  ResponseDto<[PostDto]>, NetworkError
>
