//
//  APIServices.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Alamofire
import Foundation
import SwiftUI

class BaseAPIService {
  func jsonContentTypeHttpHeaders() -> HTTPHeaders {
    [.contentType("application/json")]
  }

  func dateIso8601JsonParameterEncoder() -> JSONParameterEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return JSONParameterEncoder(encoder: encoder)
  }

  func dateMillisecondsJsonParameterEncoder() -> JSONParameterEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970
    return JSONParameterEncoder(encoder: encoder)
  }

  func prepareParameters(withData data: Codable) -> Parameters? {
    do {
      let jsonData = try JSONEncoder().encode(data)
      return try JSONSerialization.jsonObject(with: jsonData) as? Parameters
    } catch {
      print(error)
      return nil
    }
  }

  func mapResponse<T>(
    _ response: DataResponsePublisher<T>.Output
  ) -> DataResponse<T, NetworkError> {
    response.mapError { error in
      let backendError = response.data.flatMap { data in
        try? JSONDecoder().decode(BackendError.self, from: data)
      }
      return NetworkError(initialError: error, backendError: backendError)
    }
  }
}

extension BaseAPIService {
  func prepareImageMultipartData(
    _ data: Data, withName name: String, filename: String, mimeType: String
  ) -> MultipartFormData {
    let result = MultipartFormData()
    result.append(data, withName: name, fileName: filename, mimeType: mimeType)
    return result
  }

  func prepareImagesMultipartData(
    _ images: [Data], withName name: String, filenames: [String],
    mimeTypes: [String]
  ) -> MultipartFormData {
    let result = MultipartFormData()
    guard images.count == filenames.count, images.count == mimeTypes.count else { return result }
    for i in images.indices {
      result.append(
        images[i],
        withName: name,
        fileName: filenames[i],
        mimeType: mimeTypes[i]
      )
    }
    return result
  }

  func mergeMultipartFormImagesData(
    _ data: MultipartFormData,
    images: [Data],
    withName name: String,
    filenames: [String],
    mimeTypes: [String]
  ) -> MultipartFormData {
    images.enumerated().forEach { i, image in
      data.append(
        image,
        withName: name,
        fileName: filenames[i],
        mimeType: mimeTypes[i]
      )
    }
    return data
  }

  func prepareMultipartFormJSONData(
    _ data: Encodable,
    withName name: String
  ) -> MultipartFormData {
    let result = MultipartFormData()
    let jsonData = try? JSONEncoder().encode(data)
    result.append(
      jsonData ?? Data(),
      withName: name,
      mimeType: "application/json"
    )
    return result
  }
}
