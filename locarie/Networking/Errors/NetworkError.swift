//
//  NetworkError.swift
//  locarie
//
//  Created by qiuty on 28/12/2023.
//

import Alamofire
import Foundation

struct NetworkError: Error {
  let initialError: AFError?
  let backendError: BackendError?
}

struct BackendError: Error, Codable {
  let message: String
  let code: ResultCode
}

extension NetworkError {
  func description() -> String {
    if let initialError {
      ErrorMessage.network.rawValue
    } else if let backendError {
      backendError.message
    } else {
      ""
    }
  }
}

enum ResultCode: Int, Codable {
  // parameters-related codes
  case invalieParameters = 101

  // authentication-related codes
  case emailAlreadyInUse = 201
  case incorrectCredentials = 202

  case unknown
}

enum ErrorMessage: String {
  case network = "Network error, please try again later"
  case unknown = "Something went wrong, please try again later"
}
