//
//  APIServices.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Alamofire
import Foundation
import SwiftUI

enum APIServices {
  static func prepareMultipartFormJSONData(
    _ data: Encodable,
    withName name: String
  ) throws -> MultipartFormData {
    let result = MultipartFormData()
    let jsonData = try JSONEncoder().encode(data)
    result.append(jsonData, withName: name, mimeType: "application/json")
    return result
  }

  static func prepareMultipartFormImagesData(
    multipartFormData data: MultipartFormData,
    images: [Data],
    withName name: String
  ) throws -> MultipartFormData {
    images.enumerated().forEach { index, image in
      data.append(
        image,
        withName: name,
        fileName: "\(index + 1).jpg",
        mimeType: "image/jpeg"
      )
    }
    return data
  }

  static func handleError(_ error: Error) throws {
    if let afError = error.asAFError, let error = afError.underlyingError {
      throw error
    }
    throw error
  }
}
