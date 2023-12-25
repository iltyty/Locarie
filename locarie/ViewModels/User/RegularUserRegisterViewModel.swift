//
//  RegularUserRegisterViewModel.swift
//  locarie
//
//  Created by qiuty on 22/12/2023.
//

import Combine
import RegexBuilder
import SwiftUI

final class RegularUserRegisterViewModel: ObservableObject {
  @Published var dto = RegularUserRegisterRequestDto()
  @Published var isFormValid = false

  private var publishers: Set<AnyCancellable> = []

  init() {
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &publishers)
  }
}

private extension RegularUserRegisterViewModel {
  var isEmailValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      dto.email.firstMatch(of: Regexes.email) != nil
    }
    .eraseToAnyPublisher()
  }

  var isFirstNameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.firstName.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isLastNameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.lastName.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.username.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      dto.password.firstMatch(of: Regexes.password) != nil
    }
    .eraseToAnyPublisher()
  }

  var isRealNameValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(
      isFirstNameValidPublisher,
      isLastNameValidPublisher
    )
    .map { $0 && $1 }
    .eraseToAnyPublisher()
  }

  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest4(
      isEmailValidPublisher,
      isRealNameValidPublisher,
      isUsernameValidPublisher,
      isPasswordValidPublisher
    )
    .map { $0 && $1 && $2 && $3 }
    .eraseToAnyPublisher()
  }
}
