//
//  Errors.swift
//  locarie
//
//  Created by qiuty on 09/12/2023.
//

import Foundation

// Locarie Error
enum LError: Error {
  case cannotReach
}

enum NetworkError: Error {
  case unknownResponse(description: String?)
  case badStatusCode(_ statusCode: Int)
  case emptyData
  case unknown
}

enum ResultCode: Int {
  // parameters-related codes
  case invalieParameters = 101

  // authentication-related codes
  case emailAlreadyInUse = 201
  case incorrectCredentials = 202
}
