//
//  FeedbackService.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Alamofire
import Combine
import Foundation

protocol FeedbackService {
  func send(userId: Int64, content: String) -> AnyPublisher<FeedbackSendResponse, Never>
}

final class FeedbackServiceImpl: BaseAPIService, FeedbackService {
  static let shared = FeedbackServiceImpl()
  override private init() {}

  func send(userId: Int64, content: String) -> AnyPublisher<FeedbackSendResponse, Never> {
    let params = prepareSendFeedbackParams(userId: userId, content: content)
    return AF.request(APIEndpoints.feedbackUrl, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareSendFeedbackParams(userId: Int64, content: String) -> Parameters {
    [
      "userId": userId,
      "content": content,
    ]
  }
}

typealias FeedbackSendResponse = DataResponse<ResponseDto<Bool>, NetworkError>
