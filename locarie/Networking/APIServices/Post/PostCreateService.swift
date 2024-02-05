//
//  PostCreateService.swift
//  locarie
//
//  Created by qiuty on 18/12/2023.
//

import Alamofire
import Foundation

extension APIServices {
  static func createPost(dto: PostCreateRequestDto, images: [Data]) async throws
    -> ResponseDto<PostCreateResponseDto>
  {
    do {
      let data = try prepareMultipartFormData(dto: dto, images: images)
      return try await sendPostCreationRequest(multipartFormData: data)
    } catch {
      try handlePostCreationError(error)
    }
    throw LError.cannotReach
  }

  private static func prepareMultipartFormData(
    dto: PostCreateRequestDto,
    images: [Data]
  ) throws -> MultipartFormData {
    let data = try prepareMultipartFormJSONData(dto, withName: "post")
    return try prepareMultipartFormImagesData(
      multipartFormData: data,
      images: images,
      withName: "images"
    )
  }

  private static func sendPostCreationRequest(
    multipartFormData data: MultipartFormData
  ) async throws
    -> ResponseDto<PostCreateResponseDto>
  {
    try await AF
      .upload(multipartFormData: data, to: APIEndpoints.createPostUrl)
      .serializingDecodable(ResponseDto<PostCreateResponseDto>.self)
      .value
  }

  private static func handlePostCreationError(_ error: Error) throws {
    try handleError(error)
  }
}
