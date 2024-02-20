//
//  LoginViewModel.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Combine
import Foundation
import SwiftUI

final class LoginViewModel: BaseViewModel {
  @Published var dto: LoginRequestDto
  @Published var state: State = .idle
  @Published var isFormValid = false

  private let networking: LoginService
  private var subscriptions: Set<AnyCancellable> = []

  init(networking: LoginService = LoginServiceImpl.shared) {
    self.networking = networking
    dto = LoginRequestDto(email: "", password: "")
    super.init()
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &subscriptions)
  }

  func setDto(from request: RegisterRequestDto) {
    dto = LoginRequestDto(email: request.email, password: request.password)
  }
}

extension LoginViewModel {
  func login() {
    networking.login(dto: dto)
      .sink { [weak self] response in
        guard let self else { return }
        handleLoginResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleLoginResponse(_ response: LoginResponse) {
    debugPrint(response)
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      state = dto.status == 0 ? .finished(dto.data)
        : .failed(newNetworkError(response: dto))
    }
  }
}

private extension LoginViewModel {
  var isEmailValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.email.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.password.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher)
      .map { isEmailValid, isPasswordValid in
        isEmailValid && isPasswordValid
      }
      .eraseToAnyPublisher()
  }
}

extension LoginViewModel {
  enum State {
    case idle
    case loading
    case finished(UserCache?)
    case failed(NetworkError)
  }
}
