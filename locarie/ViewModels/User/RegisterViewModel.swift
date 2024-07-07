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
  @Published var isEmailValid = false
  @Published var isFirstNameValid = false
  @Published var isLastNameValid = false
  @Published var isUsernameValid = false
  @Published var isPasswordValid = false
  @Published var isBusinessNameValid = false
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
    storePublishers()
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
}

private extension RegisterViewModel {
  func storePublishers() {
    storeIsEmailValidPublisher()
    storeIsFirstNameValidPublisher()
    storeIsLastNameValidPublisher()
    storeIsUsernameValidPublisher()
    storeIsPasswordValidPublisher()
    storeIsBusinessNameValidPublisher()
    storeIsFormValidPublisher()
    storeIsBusinessFormValidPublisher()
  }

  func storeIsEmailValidPublisher() {
    isEmailValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isEmailValid, on: self)
      .store(in: &subscriptions)
  }

  func storeIsFirstNameValidPublisher() {
    isFirstNameValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFirstNameValid, on: self)
      .store(in: &subscriptions)
  }

  func storeIsLastNameValidPublisher() {
    isLastNameValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isLastNameValid, on: self)
      .store(in: &subscriptions)
  }

  func storeIsUsernameValidPublisher() {
    isUsernameValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isUsernameValid, on: self)
      .store(in: &subscriptions)
  }

  func storeIsPasswordValidPublisher() {
    isPasswordValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isPasswordValid, on: self)
      .store(in: &subscriptions)
  }

  func storeIsBusinessNameValidPublisher() {
    isBusinessNameValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isBusinessNameValid, on: self)
      .store(in: &subscriptions)
  }

  func storeIsFormValidPublisher() {
    isFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isFormValid, on: self)
      .store(in: &subscriptions)
  }

  func storeIsBusinessFormValidPublisher() {
    isBusinessFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isBusinessFormValid, on: self)
      .store(in: &subscriptions)
  }
}

extension RegisterViewModel {
  func register() {
    state = .loading
    dataPreprocessing()
    networking.register(user: dto)
      .sink { [weak self] response in
        guard let self else { return }
        handleRegisterResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func dataPreprocessing() {
    dto.trimStringFields()
  }

  private func handleRegisterResponse(_ response: RegisterResponse) {
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
      dto.email.wholeMatch(of: Regexes.email) != nil
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
      dto.username.wholeMatch(of: Regexes.username) != nil
    }
    .eraseToAnyPublisher()
  }

  var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      dto.password.wholeMatch(of: Regexes.password) != nil
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
      dto.businessName.wholeMatch(of: Regexes.businessName) != nil
    }
    .eraseToAnyPublisher()
  }

  var isBusinessCategoryValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      !dto.categories.isEmpty
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
