//
//  ProfileImagesUploadService.swift
//  locarie
//
//  Created by qiuty on 14/01/2024.
//

import Alamofire
import Combine
import Foundation

protocol ProfileImagesUploadService {
  func upload(id: Int64, data: [Data], filenames: [String], mimeTypes: [String])
    -> AnyPublisher<ProfileImagesUploadResponse, Never>
}

final class ProfileImagesUploadServiceImpl:
  BaseAPIService, ProfileImagesUploadService
{
  static let shared = ProfileImagesUploadServiceImpl()
  override private init() {}

  func upload(
    id: Int64,
    data: [Data],
    filenames: [String],
    mimeTypes: [String]
  ) -> AnyPublisher<ProfileImagesUploadResponse, Never> {
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

typealias ProfileImagesUploadResponse = DataResponse<
  ResponseDto<[String]>, NetworkError
>
