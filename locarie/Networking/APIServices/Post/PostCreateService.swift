//
//  PostCreateService.swift
//  locarie
//
//  Created by qiuty on 18/12/2023.
//

import Alamofire
import Combine
import Foundation

protocol PostCreateService {
  func create(
    _ dto: PostCreateRequestDto,
    images: [Data],
    filenames: [String],
    mimeTypes: [String]
  ) -> AnyPublisher<PostCreateResponse, Never>
}

final class PostCreateServiceImpl: BaseAPIService, PostCreateService {
  static let shared = PostCreateServiceImpl()
  override private init() {}

  func create(
    _ dto: PostCreateRequestDto,
    images: [Data],
    filenames: [String],
    mimeTypes: [String]
  ) -> AnyPublisher<PostCreateResponse, Never> {
    let data = prepareMultipartFormData(
      dto, images: images, filenames: filenames, mimeTypes: mimeTypes
    )
    return AF.upload(multipartFormData: data, to: APIEndpoints.createPost)
      .validate()
      .publishDecodable(type: ResponseDto<PostCreateResponseDto>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareMultipartFormData(
    _ dto: PostCreateRequestDto,
    images: [Data],
    filenames: [String],
    mimeTypes: [String]
  ) -> MultipartFormData {
    let json = prepareMultipartFormJSONData(dto, withName: "post")
    return mergeMultipartFormImagesData(
      json, images: images, withName: "images", filenames: filenames,
      mimeTypes: mimeTypes
    )
  }
}

typealias PostCreateResponse = DataResponse<
  ResponseDto<PostCreateResponseDto>, NetworkError
>
