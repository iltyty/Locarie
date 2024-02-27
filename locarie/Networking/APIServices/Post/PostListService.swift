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
  func listPostsNearby(latitude: Double, longitude: Double, distance: Double) ->
    AnyPublisher<PostListResponse, Never>

  func listUserPosts(id: Int64) -> AnyPublisher<PostListResponse, Never>

  func listPostsWithin(_ request: PostListWithinRequestDto) -> AnyPublisher<PostListResponse, Never>
}

final class PostListServiceImpl: BaseAPIService, PostListService {
  static let shared = PostListServiceImpl()
  override private init() {}

  func listPostsNearby(latitude: Double, longitude: Double, distance: Double) ->
    AnyPublisher<PostListResponse, Never>
  {
    let dto = PostListRequestDto(
      latitude: latitude,
      longitude: longitude,
      distance: distance
    )
    let parameters = prepareParameters(withData: dto)
    return AF.request(APIEndpoints.listPostsNearby, parameters: parameters)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func listUserPosts(id: Int64) -> AnyPublisher<PostListResponse, Never> {
    let endpoint = APIEndpoints.listUserPosts(id: id)
    return AF.request(endpoint)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func listPostsWithin(_ request: PostListWithinRequestDto) -> AnyPublisher<PostListResponse, Never> {
    let params = prepareListPostsWithinParams(request)
    return AF.request(APIEndpoints.listPostsWithin, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<[PostDto]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareListPostsWithinParams(_ request: PostListWithinRequestDto) -> Parameters {
    [
      "minLatitude": request.minLatitude,
      "maxLatitude": request.maxLatitude,
      "minLongitude": request.minLongitude,
      "maxLongitude": request.maxLongitude,
    ]
  }
}

typealias PostListResponse = DataResponse<ResponseDto<[PostDto]>, NetworkError>
