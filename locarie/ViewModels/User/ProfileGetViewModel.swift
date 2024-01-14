//
//  ProfileGetViewModel.swift
//  locarie
//
//  Created by qiuty on 08/01/2024.
//

import Combine
import Foundation

final class ProfileGetViewModel: BaseViewModel {
  @Published var dto = UserDto()
  @Published var state: State = .idle

  private let networking: ProfileGetService
  private var subscriptions: Set<AnyCancellable> = []

  init(networking: ProfileGetService = ProfileGetServiceImpl.shared) {
    self.networking = networking
  }

  func getProfile(id: Int64) {
    if case .finished = state {
      return
    }
    networking.getUserProfile(id: id)
      .sink { [weak self] response in
        guard let self else { return }
        handleGetProfileResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleGetProfileResponse(_ response: ProfileGetResponse) {
    if let error = response.error {
      state = .failed(error)
    } else {
      let dto = response.value!
      if dto.status == 0 {
        if let userDto = dto.data {
          self.dto = userDto
        }
        state = .finished
      } else {
        state = .failed(newNetworkError(response: dto))
      }
    }
  }
}

extension ProfileGetViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
