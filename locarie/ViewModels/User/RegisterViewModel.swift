//
//  RegisterViewModel.swift
//  locarie
//
//  Created by qiuty on 28/12/2023.
//

import Alamofire
import Combine
import Foundation

final class RegisterViewModel: BaseViewModel {
  @Published var dto: RegisterRequestDto
  @Published var state: State = .idle
  @Published var isFormValid = false
  @Published var isBusinessFormValid = false

  private var networking: UserRegisterService
  private var subscriptions: Set<AnyCancellable> = []

  init(
    type: UserType = .regular,
    networking: UserRegisterService = UserRegisterServiceImpl.shared
  ) {
    self.networking = networking
    dto = RegisterRequestDto()
    super.init()
    dto.type = type
    storeIsFormValidPublisher()
    storeIsBusinessFormValidPublisher()
  }

  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    if case .regular = dto.type {
      return isRegularFormValidPublisher
    }
    return Publishers.CombineLatest(
      isRegularFormValidPublisher,
      isBusinessFormValidPublisher
    )
    .map { $0 && $1 }
    .eraseToAnyPublisher()
  }

  var isRegularFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest4(
      isEmailValidPublisher,
      isRealNameValidPublisher,
      isUsernameValidPublisher,
      isPasswordValidPublisher
    )
    .map { $0 && $1 && $2 && $3 }
    .eraseToAnyPublisher()
  }

  var isBusinessFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest3(
      isBusinessNameValidPublisher,
      isBusinessCategoryValidPublisher,
      isBusinessAddressValidPublisher
    )
    .map { $0 && $1 && $2 }
    .eraseToAnyPublisher()
  }

  private func storeIsFormValidPublisher() {
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &subscriptions)
  }

  private func storeIsBusinessFormValidPublisher() {
    isBusinessFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isBusinessFormValid, on: self)
      .store(in: &subscriptions)
  }
}

extension RegisterViewModel {
  func register() {
    networking.register(user: dto)
      .sink { [weak self] response in
        guard let self else { return }
        handleRegisterResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleRegisterResponse(_ response: RegisterResponse) {
    debugPrint(response)
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      state = dto.status == 0 ? .finished
        : .failed(newNetworkError(response: dto))
    }
  }
}

extension RegisterViewModel {
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
}

private extension RegisterViewModel {
  var isBusinessNameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.businessName.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isBusinessCategoryValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.category.isEmpty
    }
    .eraseToAnyPublisher()
  }

  var isBusinessAddressValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.address.isEmpty
    }
    .eraseToAnyPublisher()
  }
}

extension RegisterViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
