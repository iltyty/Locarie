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

  private let networking: ProfileUpdateService
  private var subscriptions: Set<AnyCancellable> = []

  init(networking: ProfileUpdateService = ProfileUpdateServiceImpl.shared) {
    self.networking = networking
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

extension ProfileUpdateViewModel {
  enum State {
    case idle
    case loading
    case finished(UserDto?)
    case failed(NetworkError)
  }
}
