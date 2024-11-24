//
//  NewPasswordViewModel.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Combine
import Foundation

final class NewPasswordViewModel: ObservableObject {
  @Published var isPasswordValid = false
  @Published var isConfirmPasswordValid = false
  @Published var isFormValid = false
  @Published var password = ""
  @Published var confirmPassword = ""

  private var subscriptions: Set<AnyCancellable> = []

  init() {
    isPasswordValidPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] value in
        self?.isPasswordValid = value
      }
      .store(in: &subscriptions)
    isConfirmPasswordValidPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] value in
        self?.isConfirmPasswordValid = value
      }
      .store(in: &subscriptions)
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] value in
        self?.isFormValid = value
      }
      .store(in: &subscriptions)
  }
}

private extension NewPasswordViewModel {
  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .CombineLatest(isPasswordValidPublisher, isConfirmPasswordValidPublisher)
      .map { $0 && $1 && self.password == self.confirmPassword }
      .eraseToAnyPublisher()
  }

  var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $password.map { password in
      password.wholeMatch(of: Regexes.password) != nil
    }
    .eraseToAnyPublisher()
  }

  var isConfirmPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $confirmPassword.map { password in
      password.wholeMatch(of: Regexes.password) != nil
    }
    .eraseToAnyPublisher()
  }
}
