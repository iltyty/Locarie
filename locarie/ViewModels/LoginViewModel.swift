//
//  LoginViewModel.swift
//  locarie
//
//  Created by qiuty on 12/12/2023.
//

import Combine
import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
  @Published var dto: LoginRequestDto
  @Published var isFormValid = false

  private var publishers: Set<AnyCancellable> = []

  init() {
    dto = LoginRequestDto(email: "", password: "")
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &publishers)
  }

  func login(
    onSuccess: @escaping Completion,
    onFailure: @escaping Completion,
    onError: @escaping (Error) -> Void
  ) {
    Task {
      do {
        let dto = LoginRequestDto(email: dto.email, password: dto.password)
        let response = try await APIServices.login(dto: dto)
        handleLoginResponse(
          response,
          onSuccess: onSuccess,
          onFailure: onFailure
        )
      } catch {
        handleLoginError(error, completion: onError)
      }
    }
  }

  private func handleLoginResponse(
    _ response: Response,
    onSuccess: Completion,
    onFailure: Completion
  ) {
    debugPrint(response)
    response.status == 0
      ? handleLoginSuccess(response, completion: onSuccess)
      : handleLoginFailure(response, completion: onFailure)
  }

  private func handleLoginError(_ error: Error, completion: (Error) -> Void) {
    completion(error)
  }

  private func handleLoginSuccess(
    _ response: Response,
    completion: Completion
  ) {
    completion(response)
  }

  private func handleLoginFailure(
    _ response: Response,
    completion: Completion
  ) {
    completion(response)
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
  typealias Response = ResponseDto<LoginResponseDto>
  typealias Completion = (_ response: Response) -> Void
}
