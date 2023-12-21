//
//  PostListService.swift
//  locarie
//
//  Created by qiuty on 20/12/2023.
//

import Alamofire
import Foundation

extension APIServices {
  static func listNearbyPosts(
    latitude: Double,
    longitude: Double,
    distance: Double
  ) async throws -> ResponseDto<[PostDto]> {
    do {
      let dto = preparePostListRequestDto(
        latitude: latitude,
        longitude: longitude,
        distance: distance
      )
      let parameters = try convertDtoToParameters(dto)
      return try await sendListRequest(parameters: parameters)
    } catch {
      try handleListError(error)
    }
    throw LError.cannotReach
  }

  private static func preparePostListRequestDto(
    latitude: Double,
    longitude: Double,
    distance: Double
  ) -> PostListRequestDto {
    PostListRequestDto(
      latitude: latitude,
      longitude: longitude,
      distance: distance
    )
  }

  private static func convertDtoToParameters(_ dto: PostListRequestDto) throws
    -> Parameters?
  {
    try structToDict(data: dto)
  }

  private static func sendListRequest(parameters: Parameters?) async throws
    -> ResponseDto<[PostDto]>
  {
    let decoder = getDecoder()
    return try await AF
      .request(
        APIEndpoints.postListNearbyUrl,
        method: .get,
        parameters: parameters
      )
      .serializingDecodable(ResponseDto<[PostDto]>.self, decoder: decoder)
      .value
  }

  private static func handleListError(_ error: Error) throws {
    try handleError(error)
  }

  private static func getDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    return decoder
  }
}
