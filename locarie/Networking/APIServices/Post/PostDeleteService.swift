//
//  PostDeleteService.swift
//  locarie
//
//  Created by qiuty on 19/06/2024.
//

import Alamofire
import Combine
import Foundation

protocol PostDeleteService {
  func delete(id: Int64) -> AnyPublisher<PostDeleteResponse, Never>
}

final class PostDeleteServiceImpl: BaseAPIService, PostDeleteService {
  static let shared = PostDeleteServiceImpl()
  override private init() {}

  func delete(id: Int64) -> AnyPublisher<PostDeleteResponse, Never> {
    let endpoint = APIEndpoints.deletePost(id: id)
    return AF.request(endpoint, method: .delete)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias PostDeleteResponse = DataResponse<ResponseDto<Bool>, NetworkError>
