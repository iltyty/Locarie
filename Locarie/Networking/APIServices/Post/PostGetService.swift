//
//  PostGetService.swift
//  locarie
//
//  Created by qiuty on 17/04/2024.
//

import Alamofire
import Combine
import Foundation

protocol PostGetService {
  func getFavoredByCount(id: Int64) -> AnyPublisher<PostGetFavoredByCountResponse, Never>
}

final class PostGetServiceImpl: BaseAPIService, PostGetService {
  static let shared = PostGetServiceImpl()
  override private init() {}

  func getFavoredByCount(id: Int64) -> AnyPublisher<PostGetFavoredByCountResponse, Never> {
    let params = ["postId": id]
    return AF.request(APIEndpoints.getPostFavoredByCount, method: .get, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Int>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias PostGetFavoredByCountResponse = DataResponse<ResponseDto<Int>, NetworkError>
