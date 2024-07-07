//
//  AuthService.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Alamofire
import Combine
import Foundation

protocol AuthService {
  func forgotPassword(email: String) -> AnyPublisher<ForgotPasswordResponse, Never>
  func validateForgotPassword(email: String, code: String) -> AnyPublisher<ValidateForgotPasswordResponse, Never>
  func resetPassword(email: String, password: String) -> AnyPublisher<ResetPasswordResponse, Never>
  func validatePassword(email: String, password: String) -> AnyPublisher<ResetValidatePasswordResponse, Never>
}

final class AuthServiceImpl: BaseAPIService, AuthService {
  static let shared = AuthServiceImpl()
  override private init() {}

  func forgotPassword(email: String) -> AnyPublisher<ForgotPasswordResponse, Never> {
    let params = prepareForgotPasswordParams(email: email)
    return AF.request(APIEndpoints.forgotPasswordUrl, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func validateForgotPassword(email: String, code: String) -> AnyPublisher<ValidateForgotPasswordResponse, Never> {
    let params = prepareValidateForgotPasswordParams(email: email, code: code)
    return AF.request(APIEndpoints.validateForgotPasswordUrl, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func resetPassword(email: String, password: String) -> AnyPublisher<ResetPasswordResponse, Never> {
    let params = prepareResetPasswordParams(email: email, password: password)
    return AF.request(APIEndpoints.resetPasswordUrl, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  func validatePassword(email: String, password: String) -> AnyPublisher<ResetValidatePasswordResponse, Never> {
    let params = prepareResetValidatePasswordParams(email: email, password: password)
    return AF.request(APIEndpoints.resetValidatePasswordUrl, method: .post, parameters: params)
      .validate()
      .publishDecodable(type: ResponseDto<Bool>.self)
      .map { self.mapResponse($0) }
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

  private func prepareForgotPasswordParams(email: String) -> Parameters {
    ["email": email]
  }

  private func prepareValidateForgotPasswordParams(email: String, code: String) -> Parameters {
    [
      "email": email, "code": code,
    ]
  }

  private func prepareResetPasswordParams(email: String, password: String) -> Parameters {
    [
      "email": email, "password": password,
    ]
  }

  private func prepareResetValidatePasswordParams(email: String, password: String) -> Parameters {
    [
      "email": email, "password": password,
    ]
  }
}

typealias ForgotPasswordResponse = DataResponse<ResponseDto<Bool>, NetworkError>
typealias ValidateForgotPasswordResponse = DataResponse<ResponseDto<Bool>, NetworkError>
typealias ResetPasswordResponse = DataResponse<ResponseDto<Bool>, NetworkError>
typealias ResetValidatePasswordResponse = DataResponse<ResponseDto<Bool>, NetworkError>
