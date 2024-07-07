//
//  ProfileUpdateViewModel.swift
//  locarie
//
//  Created by qiuty on 02/01/2024.
//

import Combine
import Foundation

final class ProfileUpdateViewModel: BaseViewModel {
  @Published var dto = UserDto()
  @Published var state: State = .idle
  @Published var isFormValid = false
  @Published var isFirstNameValid = false
  @Published var isLastNameValid = false
  @Published var isUsernameValid = false
  @Published var isBusinessNameValid = false

  private let networking: ProfileUpdateService
  private var subscriptions: Set<AnyCancellable> = []

  init(networking: ProfileUpdateService = ProfileUpdateServiceImpl.shared) {
    self.networking = networking
    super.init()
    storePublishers()
  }

  func updateProfile(userId id: Int64) {
    state = .loading
    dataPreprocessing()
    networking.updateProfile(id: id, data: dto)
      .sink { [weak self] response in
        guard let self else { return }
        handleProfileUpdateResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func dataPreprocessing() {
    dto.trimStringFields()
  }

  private func handleProfileUpdateResponse(_ response: ProfileUpdateResponse) {
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      state = dto.status == 0 ? .finished(dto.data)
        : .failed(newNetworkError(response: dto))
    }
  }
}

private extension ProfileUpdateViewModel {
  var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest4(
      isFirstNameValidPublisher,
      isLastNameValidPublisher,
      isUsernameValidPublisher,
      isBusinessNameValidPublisher
    )
    .map { $0 && $1 && $2 && (!LocalCacheViewModel.shared.isBusinessUser() || $3) }
    .eraseToAnyPublisher()
  }

  var isFirstNameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      dto.firstName.wholeMatch(of: Regexes.firstName) != nil
    }
    .eraseToAnyPublisher()
  }

  var isLastNameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      dto.lastName.wholeMatch(of: Regexes.firstName) != nil
    }
    .eraseToAnyPublisher()
  }

  var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      dto.username.wholeMatch(of: Regexes.username) != nil
    }
    .eraseToAnyPublisher()
  }

  var isBusinessNameValidPublisher: AnyPublisher<Bool, Never> {
    $dto.map { dto in
      dto.businessName.wholeMatch(of: Regexes.businessName) != nil
    }
    .eraseToAnyPublisher()
  }

  func storePublishers() {
    storeIsFirstNameValidPublisher()
    storeIsLastNameValidPublisher()
    storeIsUsernameValidPublisher()
    storeIsBusinessNameValidPublisher()
    storeIsFormValidPublisher()
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
}

extension ProfileUpdateViewModel {
  enum State {
    case idle
    case loading
    case finished(UserDto?)
    case failed(NetworkError)
  }
}
