//
//  BaseViewModel.swift
//  locarie
//
//  Created by qiuty on 08/01/2024.
//

import Foundation

class BaseViewModel: ObservableObject {
  let defaultImageMimeType = "image/jpeg"

  func newNetworkError(
    response dto: ResponseDto<some Decodable>
  ) -> NetworkError {
    let code = ResultCode(rawValue: dto.status) ?? .unknown
    let backendError = BackendError(message: dto.message, code: code)
    return NetworkError(initialError: nil, backendError: backendError)
  }
}
