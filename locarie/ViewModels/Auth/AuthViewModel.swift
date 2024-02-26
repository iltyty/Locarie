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
        handleResponse(response, finishedState: .validateForgotPasswordFinished)
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

  private func handleResponse(
    _ response: DataResponse<ResponseDto<some Decodable>, NetworkError>, finishedState: State
  ) {
    debugPrint(response)
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
}

extension AuthViewModel {
  enum State {
    case idle
    case loading
    case failed(NetworkError)
    case forgotPasswordFinished
    case validateForgotPasswordFinished
    case resetPasswordFinished
  }
}
