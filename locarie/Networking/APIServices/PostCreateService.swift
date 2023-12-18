//
//  PostCreateService.swift
//  locarie
//
//  Created by qiuty on 18/12/2023.
//

import Alamofire
import Foundation

extension APIServices {
  static func createPost(dto: PostCreateRequestDto) async throws
    -> ResponseDto<PostCreateResponseDto>
  {
    do {
      let data = try prepareMultipartFormData(
        dto,
        withName: "post",
        mimeType: "application/json"
      )
      return try await sendPostCreationRequest(multipartFormData: data)
    } catch {
      try handlePostCreationError(error)
    }
    throw LError.cannotReach
  }

  private static func sendPostCreationRequest(
    multipartFormData data: MultipartFormData
  ) async throws
    -> ResponseDto<PostCreateResponseDto>
  {
    try await AF
      .upload(multipartFormData: data, to: APIEndpoints.postCreateUrl)
      .serializingDecodable(ResponseDto<PostCreateResponseDto>.self)
      .value
  }

  private static func handlePostCreationError(_ error: Error) throws {
    try handleError(error)
  }
}
