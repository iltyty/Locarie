//
//  AuthViewModel.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Alamofire
import Combine
import Foundation

final class AuthViewModel: BaseViewModel {
  @Published var state: State = .idle

  private let networking: AuthService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: AuthService = AuthServiceImpl.shared) {
    self.networking = networking
  }

  func forgotPassword(email: String) {
    state = .loading
    networking.forgotPassword(email: email)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response, finishedState: .forgotPasswordFinished)
      }
      .store(in: &subscriptions)
  }

  func validateForgotPassword(email: String, code: String) {
    state = .loading
    networking.validateForgotPassword(email: email, code: code)
      .sink { [weak self] response in
        guard let self else { return }
        handleValidateResponse(response, finishedState: .validateForgotPasswordFinished(false))
      }
      .store(in: &subscriptions)
  }

  func resetPassword(email: String, password: String) {
    state = .loading
    networking.resetPassword(email: email, password: password)
      .sink { [weak self] response in
        guard let self else { return }
        handleResponse(response, finishedState: .resetPasswordFinished)
      }
      .store(in: &subscriptions)
  }

  func validatePassword(email: String, password: String) {
    state = .loading
    networking.validatePassword(email: email, password: password)
      .sink { [weak self] response in
        guard let self else { return }
        handleValidateResponse(response, finishedState: .validatePasswordFinished(false))
      }
      .store(in: &subscriptions)
  }

  private func handleResponse(
    _ response: DataResponse<ResponseDto<some Decodable>, NetworkError>, finishedState: State
  ) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    if response.value!.status != 0 {
      state = .failed(newNetworkError(response: response.value!))
      return
    }
    state = finishedState
  }

  private func handleValidateResponse(
    _ response: DataResponse<ResponseDto<Bool>, NetworkError>, finishedState: State
  ) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    if response.value!.status != 0 {
      state = .failed(newNetworkError(response: response.value!))
      return
    }
    switch finishedState {
    case .validatePasswordFinished:
      state = .validatePasswordFinished(response.value!.data ?? false)
    case .validateForgotPasswordFinished:
      state = .validateForgotPasswordFinished(response.value!.data ?? false)
    default: state = finishedState
    }
  }
}

extension AuthViewModel {
  enum State {
    case idle
    case loading
    case failed(NetworkError)
    case forgotPasswordFinished
    case validateForgotPasswordFinished(Bool)
    case resetPasswordFinished
    case validatePasswordFinished(Bool)
  }
}
