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
  static func prepareMultipartFormData(
    _ data: Encodable,
    withName name: String,
    mimeType: String
  ) throws -> MultipartFormData {
    let result = MultipartFormData()
    let jsonData = try JSONEncoder().encode(data)
    result.append(jsonData, withName: name, mimeType: mimeType)
    return result
  }

  static func handleError(_ error: Error) throws {
    if let afError = error.asAFError, let error = afError.underlyingError {
      throw error
    }
    throw error
  }
}
