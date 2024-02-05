//
//  PostListService.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Alamofire
import Combine
import Foundation

protocol PostListService {
  func listNearbyPosts(latitude: Double, longitude: Double, distance: Double) ->
    AnyPublisher<ListNearbyPostsResponse, Never>

  func listUserPosts(id: Int64) -> AnyPublisher<ListUserPostsResponse, Never>
}

final class PostListServiceImpl: BaseAPIService, PostListService {
  static let shared = PostListServiceImpl()
  override private init() {}

  func listNearbyPosts(latitude: Double, longitude: Double, distance: Double) ->
    AnyPublisher<ListNearbyPostsResponse, Never>
  {
    let dto = PostListRequestDto(
      latitude: latitude,
      longitude: longitude,
      distance: distance
    )
    let parameters = prepareParameters(withData: dto)
    return AF.request(APIEndpoints.listNearbyPosts, parameters: parameters)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func listUserPosts(id: Int64) -> AnyPublisher<ListUserPostsResponse, Never> {
    let endpoint = APIEndpoints.listUserPosts(id: id)
    return AF.request(endpoint)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias ListNearbyPostsResponse = DataResponse<
  ResponseDto<[PostDto]>, NetworkError
>

typealias ListUserPostsResponse = DataResponse<
  ResponseDto<[PostDto]>, NetworkError
>
