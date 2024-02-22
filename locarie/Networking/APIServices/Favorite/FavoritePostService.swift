//
//  FavoritePostService.swift
//  locarie
//
//  Created by qiuty on 22/02/2024.
//

import Alamofire
import Combine
import Foundation

protocol FavoritePostService {
  func favorite(userId: Int64, postId: Int64)
    -> AnyPublisher<FavoritePostResponse, Never>
  func unfavorite(userId: Int64, postId: Int64)
    -> AnyPublisher<UnfavoritePostResponse, Never>
  func list(userId: Int64)
    -> AnyPublisher<ListFavoritePostsResponse, Never>
  func isFavoredBy(userId: Int64, postId: Int64)
    -> AnyPublisher<BusinessIsFavoredByResponse, Never>
}

final class FavoritePostServiceImpl:
  BaseAPIService, FavoritePostService
{
  static let shared = FavoritePostServiceImpl()
  override private init() {}

  func favorite(userId: Int64, postId: Int64)
    -> AnyPublisher<FavoriteBusinessResponse, Never>
  {
    let endpoint = APIEndpoints.favoritePostUrl
    let params = prepareIdsParams(userId: userId, postId: postId)
    return AF.request(endpoint, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareIdsParams(userId: Int64, postId: Int64) -> Parameters {
    ["userId": "\(userId)", "postId": "\(postId)"]
  }

  func unfavorite(userId: Int64, postId: Int64)
    -> AnyPublisher<UnfavoritePostResponse, Never>
  {
    let endpoint = APIEndpoints.unfavoritePostUrl
    let params = prepareIdsParams(userId: userId, postId: postId)
    return AF.request(endpoint, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func list(userId: Int64) -> AnyPublisher<ListFavoritePostsResponse, Never> {
    let endpoint = APIEndpoints.favoritePostUrl
    let params = prepareUserIdParam(userId: userId)
    return AF.request(endpoint, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareUserIdParam(userId: Int64) -> Parameters {
    ["userId": "\(userId)"]
  }

  func isFavoredBy(userId: Int64, postId: Int64)
    -> AnyPublisher<BusinessIsFavoredByResponse, Never>
  {
    let endpoint = APIEndpoints.businessIsFavoredByUrl
    let params = prepareIdsParams(userId: userId, postId: postId)
    return AF.request(endpoint, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias FavoritePostResponse = DataResponse<
  ResponseDto<Bool>, NetworkError
>
typealias UnfavoritePostResponse = DataResponse<
  ResponseDto<Bool>, NetworkError
>
typealias ListFavoritePostsResponse = DataResponse<
  ResponseDto<[PostDto]>, NetworkError
>
typealias PostIsFavoredByResponse = DataResponse<
  ResponseDto<Bool>, NetworkError
>
