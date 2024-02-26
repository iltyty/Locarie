//
//  UserDeleteViewModel.swift
//  locarie
//
//  Created by qiuty on 26/02/2024.
//

import Combine
import Foundation

final class UserDeleteViewModel: BaseViewModel {
  @Published var state: State = .idle

  private let networking: UserDeleteService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: UserDeleteService = UserDeleteServiceImpl.shared) {
    self.networking = networking
  }

  func delete(id: Int64) {
    state = .loading
    networking.delete(id: id)
      .sink { [weak self] response in
        guard let self else { return }
        handleDeleteResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleDeleteResponse(_ response: UserDeleteResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status != 0 {
      state = .failed(newNetworkError(response: dto))
      return
    }
    state = .finished
  }
}

extension UserDeleteViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
