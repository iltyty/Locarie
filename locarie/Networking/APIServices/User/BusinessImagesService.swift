//
//  BusinessImagesService.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import Alamofire
import Combine
import Foundation

protocol BusinessImagesService {
  func get(id: Int64) -> AnyPublisher<BusinessImagesGetResponse, Never>

  func upload(id: Int64, data: [Data], filenames: [String], mimeTypes: [String])
    -> AnyPublisher<BusinessImagesUploadResponse, Never>
}

final class BusinessImagesServiceImpl: BaseAPIService, BusinessImagesService {
  static let shared = BusinessImagesServiceImpl()
  override private init() {}

  func get(id: Int64) -> AnyPublisher<BusinessImagesGetResponse, Never> {
    let endpoint = APIEndpoints.userProfileImagesUrl(id: id)
    return AF.request(endpoint)
      .validate()
      .publishDecodable(type: ResponseDto<[String]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func upload(id: Int64, data: [Data], filenames: [String], mimeTypes: [String])
    -> AnyPublisher<BusinessImagesUploadResponse, Never>
  {
    let endpoint = APIEndpoints.userProfileImagesUrl(id: id)
    let multipartFormData = prepareImagesMultipartData(
      data,
      withName: "images",
      filenames: filenames,
      mimeTypes: mimeTypes
    )
    return AF.upload(multipartFormData: multipartFormData, to: endpoint)
      .validate()
      .publishDecodable(type: ResponseDto<[String]>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

typealias BusinessImagesGetResponse = DataResponse<ResponseDto<[String]>, NetworkError>
typealias BusinessImagesUploadResponse = DataResponse<ResponseDto<[String]>, NetworkError>
