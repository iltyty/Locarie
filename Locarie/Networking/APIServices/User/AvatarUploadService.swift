//
//  AvatarUploadService.swift
//  locarie
//
//  Created by qiuty on 13/01/2024.
//

import Alamofire
import Combine
import Foundation

protocol AvatarUploadService {
  func upload(userId id: Int64, data: Data, filename: String, mimeType: String)
    -> AnyPublisher<AvatarUploadResponse, Never>
}

final class AvatarUploadServiceImpl: BaseAPIService, AvatarUploadService {
  static let shared = AvatarUploadServiceImpl()
  override private init() {}

  func upload(
    userId id: Int64, data: Data, filename: String, mimeType: String
  ) -> AnyPublisher<AvatarUploadResponse, Never> {
    let endpoint = APIEndpoints.userAvatarUrl(id: id)
    let multipartFormData = prepareImageMultipartData(
      data, withName: "avatar", filename: filename, mimeType: mimeType
    )
    return AF.upload(multipartFormData: multipartFormData, to: endpoint)
      .validate()
      .publishDecodable(type: ResponseDto<String>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias AvatarUploadResponse = DataResponse<ResponseDto<String>, NetworkError>
