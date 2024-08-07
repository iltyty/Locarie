//
//  UserListViewModel.swift
//  locarie
//
//  Created by qiuty on 25/02/2024.
//

import Combine
import Foundation

final class UserListViewModel: BaseViewModel {
  @Published var state: State = .idle
  @Published var businesses: [UserDto] = []

  private let networking: UserListService
  private var subscriptions: Set<AnyCancellable> = []

  init(_ networking: UserListService = UserListServiceImpl.shared) {
    self.networking = networking
  }

  func listBusinesses() {
    state = .loading
    networking.listBusinesses()
      .sink { [weak self] response in
        guard let self else { return }
        handleListBusinessesResponse(response)
      }
      .store(in: &subscriptions)
  }

  private func handleListBusinessesResponse(_ response: ListBusinessesResponse) {
    if let error = response.error {
      state = .failed(error)
      return
    }
    let dto = response.value!
    if dto.status != 0 {
      state = .failed(newNetworkError(response: dto))
      return
    }
    if let result = dto.data {
      businesses = result.filter(\.isProfileComplete)
    }
    state = .finished
  }
}

extension UserListViewModel {
  enum State {
    case idle
    case loading
    case finished
    case failed(NetworkError)
  }
}
