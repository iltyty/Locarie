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
    AnyPublisher<PostListNearbyResponse, Never>
}

final class PostListServiceImpl: BaseAPIService, PostListService {
  static let shared = PostListServiceImpl()
  override private init() {}

  func listNearbyPosts(latitude: Double, longitude: Double, distance: Double) ->
    AnyPublisher<PostListNearbyResponse, Never>
  {
    let dto = PostListRequestDto(
      latitude: latitude,
      longitude: longitude,
      distance: distance
    )
    let parameters = prepareParameters(withData: dto)
    return AF.request(APIEndpoints.postListNearbyUrl, parameters: parameters)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias PostListNearbyResponse = DataResponse<
  ResponseDto<[PostDto]>, NetworkError
>
