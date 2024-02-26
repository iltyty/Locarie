//
//  NewPasswordViewModel.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Combine
import Foundation

final class NewPasswordViewModel: ObservableObject {
  @Published var isFormValid = false
  @Published var password = ""
  @Published var confirmPassword = ""

  private var subscriptions: Set<AnyCancellable> = []

  init() {
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &subscriptions)
  }
}

private extension NewPasswordViewModel {
  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .CombineLatest(isPasswordValidPublisher, isConfirmPasswordValidPublisher)
      .map { $0 && $1 }
      .eraseToAnyPublisher()
  }

  var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $password.map { password in
      password.firstMatch(of: Regexes.password) != nil
    }
    .eraseToAnyPublisher()
  }

  var isConfirmPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $confirmPassword.map { password in
      password.firstMatch(of: Regexes.password) != nil
    }
    .eraseToAnyPublisher()
  }
}
